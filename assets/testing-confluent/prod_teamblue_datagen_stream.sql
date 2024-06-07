
CREATE STREAM prod_teamblue_datagen_stream WITH (kafka_topic = 'prod.teamblue.datagen.topic', value_format = 'avro');

CREATE STREAM prod_teamblue_datagen_stream_copy WITH (KAFKA_TOPIC='prod.teamblue.datagen.topic.copy', PARTITIONS=6, REPLICAS=3) AS
SELECT *
FROM prod_teamblue_datagen_stream
         EMIT CHANGES;
