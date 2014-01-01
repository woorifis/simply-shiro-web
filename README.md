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
  * ==Session Management== : [Java Servlet](http://en.wikipedia.org/wiki/Java_Servlet)의 [HttpSession](http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpSession.html) 을 사용할 수 있기도 하지만, **Native Session**이라는 이름으로 자체적인 세션 시스템을 제공한다. HttpSession을 사용하지 않고, 굳이 이런 Native Session을 사용하면, 대부분의 [Servlet Container](http://en.wikipedia.org/wiki/Web_container)에서 제대로 제공하지 않거나, 설정하기 끔찍한 클러스터링(clustered)한 여러 컨테이너들끼리 어떤 컨테이너로 로드밸런싱(load-balanced)하여 요청을 처리하더라도, 동일한 세션을 사용할 수 있도록 하는 [session clustering](http://tomcat.apache.org/tomcat-5.5-doc/cluster-howto.html)을 매우 간편하고 적절하게 사용할 수 있다. :-)


## 왜 이걸 사용해야 하죠?

애플리케이션, 웹애플리케이션을 개발할 때 자체적으로 로그인, 회원 관리를 구현한다. 그런데, 그런 대부분의 프로젝트의 지향하는 모델은 거의 대부분 이상적인 보안 모델에서 크게 벗어나지 않고, 또 설계-개발 인원이 생각하기에 특별하다고 믿지만, 사실은 기본적인 보안 모델의 응용이거나 사실은 잘못된 설계인 경우가 더 많다고 생각한다.

그렇게 자체적으로 설계-구현한 보안 모듈이 적절하게 동작하지도 않거나, 보안성-기능이 취약하거나(*XSS, 비밀번호를 평문으로 저장, 권한 관리 부분이 미흡 등등..*)한 경우가 거의 대부분이다.

대부분의 애플리케이션은 보안 모듈을 완벽하게 구현하는게 목적이 아니고, 그 애플리케이션의 용도에 맞도록 동작하는데 더 집중하기 마련이고, 결국 보안과 관련한 부분은 미흡하게 구현하여 [기술적 부채(technical debt.)](http://en.wikipedia.org/wiki/Technical_debt)으로 남는다.

마치, Java으로 웹개발을 하면서 직접 구현한 [CGI](http://en.wikipedia.org/wiki/Common_Gateway_Interface)을 구현하거나 하여 개발하지 않듯이 말이다. 차라리 이미 잘 정립된 Java Servlet API, JSP을 활용하여 자신이 개발하려는 목적을 달성하기 위해 집중하듯이. 물론, 자신이 원하는 웹프레임웍이 정말 특이하고 Servlet API에 들어맞지 않는다면 다시 구현하는게 맞겠지만, 대부분은 그렇지 않다. ;-) 솔직히 말해서, 그 요건을 잘못 생각하고 있거나, 그 요건에 대한 접근이 잘못되었거나, 요건에 대한 *바퀴*는 이미 발명되어 있는데, 그걸 사용할 방법을 모르거나 관심이 없어서 그런 경우가 더 많다.

더욱이 Shiro의 설계는 꽤 유연해서 완벽히 내가 원하는 바에 들어맞지 않더라도, 잘 응용해서 적용하기에도 충분하다. ;-)

그리고 더 대부분의 경우에는 거의 잘 설정해서 적용하면, 최소한의 코딩만으로 잘 작동하고 기능도 풍부한 보안 프레임웍으로 꽤 괜춘하다. ㅎㅎ


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