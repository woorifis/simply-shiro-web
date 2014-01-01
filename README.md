simply-shiro-web
================

[Apache Shiro](http://shiro.apache.org/) Security Framework의 소개와 기본 개념들의 정리, Java Web Servlet/JSP와의 연동 예시.


- - -



# Apache Shiro?

[Apache Shiro](http://shiro.apache.org/) Security Framework은 Java 플랫폼을 위한 보안 프레임웍.

크게 다음과 같은 일들을 거의 아무 코드를 작성할 필요 없이 가져다 쓰거나, 정말 필요한 부분만 작성해서 거의 대부분의 보안 모듈에 기대하는 기능들을 제공 받을 수 있다. 정말 필요한 부분들은 애플리케이션에 따라서 다른 사용자-비밀번호 인증을 위한 정보를 얻는 부분과 같은 정말 애플리케이션마다 다를 부분이고, 필요한 기능들은 크게 다음과 같다. (*크게 공식 사이트에서 소개하는 내용에 따라서.*)

  * ==Authentication== : 어떤 사용자의 그 **사용자 이름(Subject, username)와 비밀번호(password)이 일치하는지** 체크. (*흔히 말하는 로그인.*)
  * ==Authorization== : Authentication에 의해서 발급 받은 **사용자 정보(Subject)이 어떤 행위를 수행하는데 적절한지 체크**. (*흔히 말하는 권한 검사.*) Authentication으로 로그인이 되었을지라도, 관리자로서의 권한은 없을 수 있다. 이런 권한의 구분은 Authorization에 속한다. (물론, 그런 권한이 있는 사람인지 아닌지, 그 증명인 Subject의 발급은 Authetication이지만.)
  * ==Cryptography== : 비밀번호를 직접 평문(plaintext, cleartext)으로 저장하지 않고, 암호화하거나 체크섬을 저장하도록, [SHA](http://en.wikipedia.org/wiki/Secure_Hash_Algorithm)등의 **암호화 알고리즘을 사용하기 편리하도록 제공**. Java에서 이러한 기능은 별도의 프레임웍이나 [JCA](http://docs.oracle.com/javase/6/docs/technotes/guides/security/crypto/CryptoSpec.html)등을 통해서 사용하는데, 사용하기가 그렇게 편리하지는 않은데, Shiro에서는 그냥 딱 적절하게 동작하도록 잘 제공해줌. ㅎㅎ
  * ==Session Management== : [Java Servlet](http://en.wikipedia.org/wiki/Java_Servlet)의 [HttpSession](http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpSession.html) 을 사용할 수 있기도 하지만, 
  
  

## 적용 방식.

## Spring Security와의 차이.

## 다른 프레임웍과의 연동.

  * [Spring](http://spring.io/), [Guice](https://code.google.com/p/google-guice/)등의 프레임웍과 연동이 이미 있음. ㅎㅎ
  	* [Guice 연동](http://shiro.apache.org/guice.html)
  	* [Spring 연동](http://shiro.apache.org/spring.html)
  
### Spring Web MVC와의 연동 예시.

  * Spring, Spring WebMVC와의 연동은 https://github.com/ageldama/shiro-spring-web 여기를 참고. ㅎㅎ (문서는 아직 작성 중)
  
  
### Stormpath?






- - -


# 예제 소스.



## 프로젝트 세팅 방법.
  
  * Maven 3에 맞춰 개발하였으며, https://github.com/ageldama/simply-shiro-web 프로젝트를 checkout하여 소스를 가져옵니다.
  * 자신이 사용하는 Java IDE에 따라서 "Import / Maven Project"으로 소스를 가져와 프로젝트를 세팅하면 됩니다.


## 실행 방법.

  * 직접 Maven 3을 이용하여 실행하려면, 커맨드라인(`cmd.exe` 혹은 터미널/쉘)에서 다음과 같이 실행합니다.
  	* (**소스 디렉토리에서**) `mvn tomcat7:run`
  	* [Embedded Tomcat 7](http://tomcat.apache.org/maven-plugin-2.1/tomcat7-maven-plugin/run-mojo.html)으로 자동 실행합니다. HTTP으로 TCP/8080으로 엽니다.
  	* 실행한 다음 웹브라우저로 http://localhost:8080/ 을 열어봅니다.



- - -




* Servlet/JSP + Apache Shiro.
* login, logout.
* simple authenticated checks, roles checks.

* login failure message?
	- ${shiroLoginFailure}
	- request.getAttribute("shiroLoginFailure");
	- 문자열임. ㅎㅎ 

 
* "remember me"?
- SEE: http://shiro.apache.org/web.html#Web-RememberMeServices
	    - rememberMe으로 얻은 권한은 authenticated이 아니라, user 상태임.
	    - <shiro:authenticated/>이 아니라 <shiro:user/>이 다르고.
	    - shiro.ini에서도 authc 필터가 아니라 user 필터로 검사.



 
* Spring Security와의 차이.

자바 단독 라이브러리로서의 위상.

Authentication, Authorization의 차이.

Permissions, Roles.

Realms, SecurityManager, SessionManager, SessionDAO, Principals, Subject.


자바 웹애플리케이션과의 연동.

서블릿과의 연계 방식.

shiro.ini

[urls], filters

login, logout, remember me.

unauthorized-url, successful-url, logout-redirect-url.

anon, authc, logout, perms, roles, user, ssl, noSessionCreation, rest, authcBasic

JSP Taglib.

Sessions, Caches: Native Sessions.
	- SEE: http://shiro.apache.org/session-management.html
	- http://grokbase.com/t/shiro/user/097qez5sys/exception-there-is-no-session-with-id
	- securityManager.sessionManager와 sessionDAO을 같이 설정하니 잘 굴러가는듯.

    	This implementation defaults to using an in-memory map-based CacheManager, which is great for testing but will typically not scale for production environments and could easily cause OutOfMemoryExceptions. Just don't forget to configure* an instance of this class with a production-grade CacheManager that can handle disk paging for large numbers of sessions and you'll be fine.

    - securityManager.cacheManager도 같이 설정해줘야함. ㅎㅎ