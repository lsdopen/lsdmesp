package io.lsdopen.lsdmesp.service.notification;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public final class ConfigUtility {

    private ConfigUtility() {
    }

    public static Properties loadProperties(String config) throws IOException {
        if (config == null) {
            return new Properties();
        }

        if (!Files.exists(Paths.get(config))) {
            throw new IOException(config + " not found.");
        }

        Properties properties = new Properties();
        try (InputStream is = new FileInputStream(config)) {
            properties.load(is);
        }
        return properties;
    }
}
