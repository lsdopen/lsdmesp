package io.lsdopen.lsdmesp.service.notification;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Properties;

public class MailUtility {

    private static final Logger log = LoggerFactory.getLogger(MailUtility.class);

    private final String smtpHost;
    private final String smtpPort;
    private final String smtpUsername;
    private final String smtpPassword;
    private final String smtpFromEmail;
    private final String smtpToEmail;

    public MailUtility(String mailConfig) throws IOException {
        Properties properties = ConfigUtility.loadProperties(mailConfig);
        smtpHost = properties.getProperty("smtp.host");
        smtpPort = properties.getProperty("smtp.port");
        smtpUsername = properties.getProperty("smtp.username");
        smtpPassword = properties.getProperty("smtp.password");
        smtpFromEmail = properties.getProperty("smtp.from.email");
        smtpToEmail = properties.getProperty("smtp.to.email");
    }

    public void sendMail(String msg, String subject, String toEmail) throws MessagingException {
        if (toEmail == null) {
            log.debug("Overriding empty toEmail with value from config: " + smtpToEmail);
            toEmail = smtpToEmail;
        }

        Properties prop = new Properties();
        prop.put("mail.smtp.auth", true);
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", smtpHost);
        prop.put("mail.smtp.port", smtpPort);
        prop.put("mail.smtp.ssl.trust", smtpHost);
        prop.put("mail.smtp.connectiontimeout", "20000");
        prop.put("mail.smtp.timeout", "20000");

        Session session = Session.getInstance(prop, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(smtpUsername, smtpPassword);
                    }
                }
        );

        MimeBodyPart mimeBodyPart = new MimeBodyPart();
        mimeBodyPart.setContent(msg, "text/html; charset=utf-8");
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(mimeBodyPart);

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(smtpFromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(multipart);

        Transport.send(message);

        log.info("Successfully sent mail with subject {} to {}", subject, toEmail);
    }
}
