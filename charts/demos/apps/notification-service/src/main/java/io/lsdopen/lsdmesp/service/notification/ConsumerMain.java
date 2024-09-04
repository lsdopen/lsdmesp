package io.lsdopen.lsdmesp.service.notification;

import com.beust.jcommander.JCommander;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import io.confluent.kafka.serializers.KafkaAvroDeserializerConfig;
import org.apache.kafka.clients.CommonClientConfigs;
import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.util.Utf8;

import java.io.IOException;
import java.time.Duration;
import java.util.Collections;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;

public class ConsumerMain {
    private static final Logger log = LoggerFactory.getLogger(ConsumerMain.class);

    public static void main(final String[] args) {
        //
        // Parse input args
        //
        Args inputArgs = new Args();
        JCommander jc = JCommander.newBuilder()
                .addObject(inputArgs)
                .build();
        try {
            jc.parse(args);

            if (inputArgs.isHelp()) {
                jc.usage();
                System.exit(0);
            }
        } catch (Exception ex) {
            System.err.println(ex.getLocalizedMessage());
            jc.usage();
            System.exit(1);
        }

        String bootstrapServers = inputArgs.getBootstrapServers();
        String schemaRegistryUrl = inputArgs.getSchemaRegistryUrl();
        String sourceTopic = inputArgs.getSourceTopic();
        Long maxIdleTimeMillis = inputArgs.getMaxIdleTimeMillis();
        String commandConfig = inputArgs.getCommandConfig();
        String mailConfig = inputArgs.getMailConfig();

        log.info("Consuming events with input arguments: '{}'", inputArgs);

        if (maxIdleTimeMillis == null) {
            maxIdleTimeMillis = Long.MAX_VALUE;
        }

        // Init shutdown hook
        final AtomicBoolean runConsumerLoop = new AtomicBoolean(true);
        final CountDownLatch shutdownLatch = new CountDownLatch(1);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            log.info("Stopping consumer loop ...");
            try {
                runConsumerLoop.set(false);
                shutdownLatch.await();
            } catch (InterruptedException ex) {
                log.error("Wait interrupted", ex);
            }
            log.info("Exiting shutdown hook!");
        }));

        try {
            consumeEvents(bootstrapServers, schemaRegistryUrl, sourceTopic,
                    maxIdleTimeMillis, commandConfig, mailConfig, runConsumerLoop);
        } catch (Exception ex) {
            log.error("Failed to consume events", ex);
        } finally {
            // Allow shutdown hook to complete
            shutdownLatch.countDown();
        }

        log.info("Exiting main!");
    }

    private static void consumeEvents(
            String bootstrapServers,
            String schemaRegistryUrl,
            String sourceTopic,
            Long maxIdleTimeMillis,
            String commandConfig,
            String mailConfig,
            AtomicBoolean runConsumerLoop) throws IOException {

        final Properties consumerProps = getDefaultProps(bootstrapServers, commandConfig);
        consumerProps.put(ConsumerConfig.GROUP_ID_CONFIG, "demo-notification-service-consumer");
        consumerProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        consumerProps.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, "1000");
        consumerProps.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        consumerProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        consumerProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
        consumerProps.put(KafkaAvroDeserializerConfig.SPECIFIC_AVRO_READER_CONFIG, "false");
        consumerProps.put(KafkaAvroDeserializerConfig.SCHEMA_REGISTRY_URL_CONFIG, schemaRegistryUrl);

        MailUtility mailUtility = new MailUtility(mailConfig);

        try (Consumer<GenericRecord, GenericRecord> consumer = new KafkaConsumer<>(consumerProps)) {
            //
            // Continue from committed offsets
            //
            consumer.subscribe(Collections.singletonList(sourceTopic));

            log.info("Starting consumer loop");
            int counter = 0;
            Long firstIdleTimeMillis = null;
            while (runConsumerLoop.get()) {
                ConsumerRecords<GenericRecord, GenericRecord> records = consumer.poll(Duration.ofMillis(100));

                if (!records.isEmpty()) {
                    if (firstIdleTimeMillis != null) {
                        long diffMillis = System.currentTimeMillis() - firstIdleTimeMillis;
                        log.trace("Received '{}' records after being idle for '{}' millis", records.count(), diffMillis);
                        firstIdleTimeMillis = null;
                    }

                    // Process all records
                    for (ConsumerRecord<GenericRecord, GenericRecord> record : records) {
                        log.debug("Processing record with key '{}', timestamp '{}' and value '{}'", record.key(), DateUtility.toStringDateTimeSAST(new Date(record.timestamp())), record.value());

                        try {
                            Integer trxAmount = (Integer) record.value().get("TRANSACTION_AMOUNT");
                            Utf8 trxId = (Utf8) record.value().get("TRANSACTION_ID");
                            Utf8 trxTime = (Utf8) record.value().get("TRANSACTION_TIME");
                            Utf8 trxFullName = (Utf8) record.value().get("FULL_NAME");
                            Utf8 trxEmail = (Utf8) record.value().get("EMAIL_ADDRESS");

                            if (trxFullName == null || trxEmail == null) {
                                log.warn("Skipping record with missing client details");
                            } else {
                                log.info("Sending email with trxAmount [" + trxAmount
                                        + "] trxTime [" + trxTime
                                        + "] trxFullName [" + trxFullName
                                        + "] trxEmail [" + trxEmail + "]");

                                String msg = "New transaction for " + trxFullName + " (" + trxEmail
                                        + ")<br/><br/>Amount: " + trxAmount
                                        + "<br/>Email: " + trxEmail
                                        + "<br/>Received: " + trxTime
                                        + "<br/>TransactionId: " + trxId;

                                String subject = "New transaction for " + trxFullName + " and amount " + trxAmount;

                                mailUtility.sendMail(msg, subject, null);
                            }
                        } catch (Exception ex) {
                            log.error("Failed to process record with key '{}'", record.key(), ex);
                        }

                        counter++;
                    }

                    // Commit after handling records
                    consumer.commitAsync((offsets, exception) -> log.trace("Committed offsets"));
                } else {
                    if (firstIdleTimeMillis == null) {
                        firstIdleTimeMillis = System.currentTimeMillis();
                        log.trace("Recording first idle time poll millis '{}'", firstIdleTimeMillis);
                    } else {
                        long diffMillis = System.currentTimeMillis() - firstIdleTimeMillis;
                        if (diffMillis > maxIdleTimeMillis) {
                            log.debug("Exiting poll loop after '{}' millis", diffMillis);
                            runConsumerLoop.set(false);
                            break;
                        }
                    }
                }
            }
            log.info("Stopped consumer loop with counter '{}'", counter);
        } finally {
            log.info("Closed consumer");
        }
    }

    private static Properties getDefaultProps(String bootstrapServers, String commandConfig) throws IOException {
        Properties properties = ConfigUtility.loadProperties(commandConfig);
        properties.put(CommonClientConfigs.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        return properties;
    }
}
