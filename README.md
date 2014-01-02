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

그리고 내가 생각할 때 멋진 기능들은...

  * Spring/Guice와 같은 DI프레임웍과의 연동도 이미 제공하고 있고,
  * Spring WebMVC, Jersey와 같은 웹프레임웍과의 연동에 제약도 없고. 
  * AOP을 통해 `@RequiresUser`와 같은 어노테이션으로 메서드를 지정하여 권한 검사를 지정할 수도 있고,  
  * JSP Custom Tag등을 지원하여, `<shiro:authenticated>...</shiro:authenticated>` 같은 태그들을 통해 웹개발시에도 권한 검사에 따른 내용을 달리 표시

그 이외에도 적용하면서, 상황에 따라 정말 유연하고 사용할만 하구나 느낄 수 있음. ㅎㅎ



## 왜 이걸 사용해야 하죠?

애플리케이션, 웹애플리케이션을 개발할 때 자체적으로 로그인, 회원 관리를 구현한다. 그런데, 그런 대부분의 프로젝트의 지향하는 모델은 거의 대부분 이상적인 보안 모델에서 크게 벗어나지 않고, 또 설계-개발 인원이 생각하기에 특별하다고 믿지만, 사실은 기본적인 보안 모델의 응용이거나 사실은 잘못된 설계인 경우가 더 많다고 생각한다.

그렇게 자체적으로 설계-구현한 보안 모듈이 적절하게 동작하지도 않거나, 보안성-기능이 취약하거나(*XSS, 비밀번호를 평문으로 저장, 권한 관리 부분이 미흡 등등..*)한 경우가 거의 대부분이다.

대부분의 애플리케이션은 보안 모듈을 완벽하게 구현하는게 목적이 아니고, 그 애플리케이션의 용도에 맞도록 동작하는데 더 집중하기 마련이고, 결국 보안과 관련한 부분은 미흡하게 구현하여 [기술적 부채(technical debt.)](http://en.wikipedia.org/wiki/Technical_debt)으로 남는다.

마치, Java으로 웹개발을 하면서 직접 구현한 [CGI](http://en.wikipedia.org/wiki/Common_Gateway_Interface)을 구현하거나 하여 개발하지 않듯이 말이다. 차라리 이미 잘 정립된 Java Servlet API, JSP을 활용하여 자신이 개발하려는 목적을 달성하기 위해 집중하듯이. 물론, 자신이 원하는 웹프레임웍이 정말 특이하고 Servlet API에 들어맞지 않는다면 다시 구현하는게 맞겠지만, 대부분은 그렇지 않다. ;-) 솔직히 말해서, 그 요건을 잘못 생각하고 있거나, 그 요건에 대한 접근이 잘못되었거나, 요건에 대한 *바퀴*는 이미 발명되어 있는데, 그걸 사용할 방법을 모르거나 관심이 없어서 그런 경우가 더 많다.

더욱이 Shiro의 설계는 꽤 유연해서 완벽히 내가 원하는 바에 들어맞지 않더라도, 잘 응용해서 적용하기에도 충분하다. ;-)

그리고 더 대부분의 경우에는 거의 잘 설정해서 적용하면, 최소한의 코딩만으로 잘 작동하고 기능도 풍부한 보안 프레임웍으로 꽤 괜춘하다. ㅎㅎ


## 적용 방식.

  * 자바 애플리케이션에 직접 : http://shiro.apache.org/10-minute-tutorial.html
  	* 자바 코드만으로 로그인, 권한 검사와 같은 것들을 어떻게 수행하는지. 자바 보안 프레임웍으로서 어떻게 적용하는지 보임.
  	* Java Servlet/JSP, 혹은 Spring WebMVC등 웹애플리케이션에서는 실제로 이렇게 적용하지 않아도 되며, 내부적으로 어떻게 동작하는지 대략적인 흐름을 볼 수 있음.
  	
  * Java Servlet/JSP에서의 연동 : 이 README의 소스코드가 예제로 보이는 내용.
    * Spring WebMVC와의 연동은 이하의 **Spring Web MVC와의 연동 예시** 부분을 참고.
    * 참고: http://shiro.apache.org/webapp-tutorial.html
    	* Stormapath을 기반으로 설명.
    	* 어쨌든 완전한 모든 내용을 친절하게 소개하고 있지는 않지만, 개념을 잡기에 괜춘함.


## Spring Security와의 차이.

[Spring Security](http://projects.spring.io/spring-security/) 보안 프레임웍도 보안 프레임웍으로서 Java만으로 사용할 수도 있고, Java Servlet/JSP와 함께 연동하여 사용할 수 있다. 물론, Spring Framework을 사용한다는 전제하에. ㅎㅎ Google Guice등을 활용하여 프로젝트를 하고 있다면, 적용하기 어렵다.

그리고 더 큰 차이점은 내가 생각하기에, Spring Security의 경우에는 별로 내가 관심도 없는 내용들을 위해서 뭔가 필터를 세팅하고, 뭔가 어떤 마법과 같은 일들을 더 해줘야, 겨우 그럭저럭 동작하는 환경을 조성할 수 있는데 반해서, Apache Shiro의 경우에는 그런 제약도 없이 그냥 딱 내가 필요한 설정들만으로 적절하게 잘 동작한다는 점인거 같다.


## 다른 프레임웍과의 연동.

  * [Spring](http://spring.io/), [Guice](https://code.google.com/p/google-guice/)등의 프레임웍과 연동이 이미 있음. ㅎㅎ
  	* [Guice 연동](http://shiro.apache.org/guice.html)
  	* [Spring 연동](http://shiro.apache.org/spring.html)
  
### Spring Web MVC와의 연동 예시.

  * Spring, Spring WebMVC와의 연동은 https://github.com/ageldama/shiro-spring-web 여기를 참고. ㅎㅎ (문서는 아직 작성 중)
  
  
### Stormpath?

  * http://www.stormpath.com/
  * Shiro을 사용하면서, 최소한 회원가입, 로그인을 위한 사용자-비밀번호(혹은 비밀번호의 체크섬 값)의 조회 로직과 같은 부분은 구현할 필요가 있음. 전자는 필요에 따라서 회원가입이 필요하다면, 구현해야하고, 그에 따라 확인 이메일 발송 등등의 또 다른 이슈들이 있고. 그런데, Stormpath에서 그런 내용들을 전부 구현하여 서비스로 제공하고, 이에 Shiro을 연동하여 바로 사용할 수 있다. ㅎㅎ
  	* 참고: http://www.stormpath.com/blog/stormpath-apache-shiro-love





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


## 기타.

  * 원래는 [logback](http://logback.qos.ch/)을 logging으로 [사용/설정](http://shiro.apache.org/webapp-tutorial.html#project-setup)이 원래 Shiro문서에 소개된 내용임.
  	* ㅎㅎ 그리고 log4j보다는 logback이 더 나을거 같음. 꼭 log4j을 쓸 필요는 없고, 가능하면 logback쓰세요. ㅎㅎㅎ
  	* logback이 초기화 성능이나 대부분의 경우에 훨씬 가볍고, 설정도 쓸만함. ㅎㅎ
  		* XML으로 설정하는건 정말 끔찍한데, 융통성도 없고, 마냥 길어만 지기 쉬움. `src/main/resources/logback.groovy`에 간략한 그루비 코드로 설정하고 있음.
  	* 어차피 제대로 로깅 관련을 정리하면, [slf4j](http://www.slf4j.org/)을 사용하여 코드에서 로그를 찍고, 그 내용을 log4j, logback등의 logging-backend에서 출력하므로, 코드는 변할게 없음.
  		* 참고: [LOGBACK 사용해야 하는 이유 (REASONS TO PREFER LOGBACK OVER LOG4J)](http://beyondj2ee.wordpress.com/2012/11/09/logback-%EC%82%AC%EC%9A%A9%ED%95%B4%EC%95%BC-%ED%95%98%EB%8A%94-%EC%9D%B4%EC%9C%A0-reasons-to-prefer-logback-over-log4j/)
  		* 참고: [LOG4J에서 LOGBACK으로 마이그레이션 하기 ( MIGRATE FROM LOG4J TO LOGBACK)](http://beyondj2ee.wordpress.com/2013/11/05/log4j%EC%97%90%EC%84%9C-logback%EC%9C%BC%EB%A1%9C-%EB%A7%88%EC%9D%B4%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%85%98-%ED%95%98%EA%B8%B0-migrate-from-log4j-to-logback/)


- - -


# Concepts

우선 실제 코드에 대한 내용을 시작하기 전에 몇가지 용어들(terms)을 소개하고 시작하려고함.

어차피 대부분 코드를 읽으면서 문맥을 통해 파악해도 괜찮으므로, 건너뛰어도 좋음. ㅎㅎ

실제 클래스가 있는 경우에는 클래스 이름으로 설명하였고, 클래스는 직접적으로 들어 설명하기는 그렇고, 개념/기능으로서만 존재한다면 이는 용어로만 소개한다.

## 몇가지 용어들.

* **Roles** : 어떤 사용자가 로그인(authenticated)하였을때, 그에게 부여된 행위 역할. 혹은 어떤 그룹(groups)에 속한다와 같은 내용을 표현.
*  **Permissions** : Roles와 유사하지만, 개별 하나의 행위에 대한 권한을 의미함. Roles의 역할이 어떤 행위들의 묶음이나, 어떤 그룹, 어떤 집합에 속함을 표현하는데 적합하다면, Permission은 어떤 행위(verbs)이나 어떤 특정 대상에 대한 행위를 표현.
* **Remember Me** : 모든 웹브라우저를 닫고, 시간이 경과하여 세션이 종료된 다음에도 웹브라우저의 보관되는 쿠키 등을 활용하여 다시 방문하였을 때, 자동적으로 로그인 상태로 남겨놓는다. 
	* "*로그인된 상태*"는 *Authenticated*이라고 부르는데, Shiro은 자체적으로 "*Remember Me*"을 통해서 획득한 로그인 상태에 대해서는 "*user*"이라고 부른다. (예: 직접 이번 세션에서 로그인한 경우엔 `@RequiresAuthentication`으로 검사하지만, "Remember Me"으로 획득한 로그인은 `@RequiresAuthentication`에서 실패한다. 대신 "Remember Me" 획득도 인정해주는 `@RequiresUser`을 구분한다.)


## 주요 클래스, 인터페이스들.

* **`SecurityManager`** : 실제로 주어진 아이디-비밀번호가 맞는지 일치를 체크하거나, 그에 따라서 로그인한 결과 세션을 발급하여 로그인 처리를 수행하거나, 로그아웃을 수행하거나, 세션에 주어진 권한-역할 등을 검사하거나 하는 역할을 한다. 이후에 소개하는 `SessionManager`, `Realm`등에 그런 개별 작업들을 위임한다.
	* 실제 구현체는 자바 애플리케이션으로 구성할 때와 자바 웹애플리케이션으로 구성할 때 사용할 수 있는, 미리 작성-구성된 클래스들을 제공한다.
	* `DefaultSecurityManager`, `DefaultWebSecurityManager`인데, 이들은 각각 `SessionManager`이기도 하고, `SessionDAO`, `CacheManager`, `Realm`들을 갖는데, 이러한 구성은 사용하는 방법에 따라서 설정하여 원하는대로 구성이 가능하다.
* **`SessionManager`** : 세션의 발급 등과 관련. 대부분의 경우에는 `DefaultSecurityManager`, `DefaultWebSecurityManager`을 사용함에 따라서 알아서 잘 구성되고, 잘 동작한다. ㅎㅎ
	1. Servlet Container에서 제공하는 `HttpSession`을 세션으로 사용하려면, `SecurityManager`에 `ServletContainerSessionManager`을 설정한다.
	2. Shiro이 구현하고 관리하는 Session인 Native Sessions을 활용하려면, `DefaultWebSessionManager`을 `SecurityManager`에 설정한다. 
* **`SessionDAO`** : 세션을 어디에 저장하고 관리하는지에 대한 실제 내용.
	* SessionManager을 Shiro Native Session을 사용하도록 설정했다면, Map을 통해 구현한 테스트용인 `MemorySessionDAO`이나, 이후에 소개할 CacheManager을 활용하는 `EnterpriseCacheSessionDAO`을 설정한다. 
* **`Realm`** : 
* `Subject`
*  `Principal` 
*  `UsernamePasswordToken`, *Credentials* 
* **`CacheManager`** : `SecurityManager`에 설정한다. Shiro에서 캐쉬를 위해서 사용하거나, 위에서 소개한 Shiro Native Sessions을 활용하고, SessionDAO으로 `EnterpriseCacheSessionDAO`을 선택했다면, `SecurityManager`에 설정한 `CacheManager`을 활용한다.
	*  설정하지 않으면, 기본은 `MemoryConstrainedCacheManager`이므로, 메모리를 많이 잡아먹고, 실제로 다른 서버와 클러스터링을 적용할 수 없는 테스트-개발용.
	*  `EhCacheManager`을 활용해서 [Ehcache](http://ehcache.org/)을 활용할 수 있다. ehcache은 여러 서버들끼리 동기화를 설정할 수 있고, 캐쉬에 대한 정밀한 설정과 JVM 힙메모리 대신 디스크 임시 디렉토리를 활용하거나 하는 설정도 가능함. ㅎㅎ
	*  다른 cache-backend을 적용하려면, 단순히 `EhCacheManager`와 같이 하나 구현하여 지정하면됨. 
* `SecurityUtils`


---

# 이하는 TBD...


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
    
끝.    