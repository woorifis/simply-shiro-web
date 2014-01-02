import ch.qos.logback.core.*;
import ch.qos.logback.core.encoder.*;
import ch.qos.logback.core.read.*;
import ch.qos.logback.core.rolling.*;
import ch.qos.logback.core.status.*;
import ch.qos.logback.classic.net.*;
import ch.qos.logback.classic.encoder.PatternLayoutEncoder;

// APPENDERS

def appenderList = []

if (true) {
    appender("CONSOLE", ConsoleAppender) {
        encoder(PatternLayoutEncoder) {
            pattern = "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
        }
    }
    //
    appenderList.add("CONSOLE")
}

root(DEBUG, appenderList)

// CLASSES

logger("jhyun", DEBUG)


[
        "org.springframework.core",
        "org.springframework.beans",
        "org.springframework.context",
        "org.springframework.web",
        "net.sf.ehcache.store",
].each {
    logger(it, INFO)
}


// EOF.