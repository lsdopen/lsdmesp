/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.lsdopen.lsdmesp.service.notification;

import com.beust.jcommander.JCommander;
import org.junit.*;

import static org.junit.Assert.*;

/**
 * ArgsTest
 *
 * @author rschamm
 */
public class ArgsTest {
    public ArgsTest() {
    }

    @BeforeClass
    public static void setUpClass() {
    }

    @AfterClass
    public static void tearDownClass() {
    }

    @Before
    public void setUp() {
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testExampleArgs() {
        System.out.println("testExampleArgs");

        Args args = new Args();
        String[] argv = {
                "--bootstrap-servers", "localhost:9092",
                "--schema-registry-url", "http://localhost:8081",
                "--source-topic", "fun-data",
                "--max-idle-millis", "10000"
        };
        JCommander.newBuilder()
                .addObject(args)
                .build()
                .parse(argv);

        assertEquals("localhost:9092", args.getBootstrapServers());
        assertEquals("http://localhost:8081", args.getSchemaRegistryUrl());
        assertEquals("fun-data", args.getSourceTopic());
        assertEquals(10000L, (long) args.getMaxIdleTimeMillis());
    }

    @Test
    public void testExampleArgsOnlyRequired() {
        System.out.println("testExampleArgsOnlyRequired");

        Args args = new Args();
        String[] argv = {
                "--bootstrap-servers", "localhost:9092",
                "--schema-registry-url", "http://localhost:8081",
                "--source-topic", "fun-data"
        };
        JCommander.newBuilder()
                .addObject(args)
                .build()
                .parse(argv);

        assertEquals("localhost:9092", args.getBootstrapServers());
        assertEquals("http://localhost:8081", args.getSchemaRegistryUrl());
        assertEquals("fun-data", args.getSourceTopic());
        assertNull(args.getMaxIdleTimeMillis());
    }

    @Test(expected = com.beust.jcommander.ParameterException.class)
    public void testExampleArgsMissingParam() {
        System.out.println("testExampleArgsMissingParam");

        Args args = new Args();
        String[] argv = {
                "--bootstrap-servers", "localhost:9092"
        };
        JCommander.newBuilder()
                .addObject(args)
                .build()
                .parse(argv);
    }
}
