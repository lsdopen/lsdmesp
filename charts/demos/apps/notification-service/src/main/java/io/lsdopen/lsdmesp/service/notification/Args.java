package io.lsdopen.lsdmesp.service.notification;

import com.beust.jcommander.Parameter;

public class Args {
    @Parameter(
            names = "--bootstrap-servers",
            description = "List of Kafka brokers",
            required = true
    )
    private String bootstrapServers;

    @Parameter(
            names = "--schema-registry-url",
            description = "The URL of the schema registry",
            required = true
    )
    private String schemaRegistryUrl;

    @Parameter(
            names = "--source-topic",
            description = "The topic to consume data from",
            required = true
    )
    private String sourceTopic;

    @Parameter(
            names = "--max-idle-millis",
            description = "The maximum amount of time to wait for messages before quitting"
    )
    private Long maxIdleTimeMillis;

    @Parameter(
            names = "--command-config",
            description = "A property file with additional (security) config"
    )
    private String commandConfig;

    @Parameter(
            names = "--mail-config",
            description = "A property file with mail config",
            required = true
    )
    private String mailConfig;

    @Parameter(
            names = "--help",
            description = "Shows the description for all parameters",
            help = true)
    private boolean help;

    public String getBootstrapServers() {
        return bootstrapServers;
    }

    public void setBootstrapServers(String bootstrapServers) {
        this.bootstrapServers = bootstrapServers;
    }

    public String getSchemaRegistryUrl() {
        return schemaRegistryUrl;
    }

    public void setSchemaRegistryUrl(String schemaRegistryUrl) {
        this.schemaRegistryUrl = schemaRegistryUrl;
    }

    public String getSourceTopic() {
        return sourceTopic;
    }

    public void setSourceTopic(String sourceTopic) {
        this.sourceTopic = sourceTopic;
    }

    public Long getMaxIdleTimeMillis() {
        return maxIdleTimeMillis;
    }

    public void setMaxIdleTimeMillis(Long maxIdleTimeMillis) {
        this.maxIdleTimeMillis = maxIdleTimeMillis;
    }

    public String getCommandConfig() {
        return commandConfig;
    }

    public void setCommandConfig(String commandConfig) {
        this.commandConfig = commandConfig;
    }

    public String getMailConfig() {
        return mailConfig;
    }

    public void setMailConfig(String mailConfig) {
        this.mailConfig = mailConfig;
    }

    public boolean isHelp() {
        return help;
    }

    public void setHelp(boolean help) {
        this.help = help;
    }

    @Override
    public String toString() {
        return "Args{" +
                "bootstrapServers='" + bootstrapServers + '\'' +
                ", schemaRegistryUrl='" + schemaRegistryUrl + '\'' +
                ", sourceTopic='" + sourceTopic + '\'' +
                ", maxIdleTimeMillis=" + maxIdleTimeMillis +
                ", commandConfig='" + commandConfig + '\'' +
                ", mailConfig='" + mailConfig + '\'' +
                ", help=" + help +
                '}';
    }
}
