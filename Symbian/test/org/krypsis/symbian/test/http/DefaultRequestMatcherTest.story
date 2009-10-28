import org.krypsis.symbian.http.DefaultRequestMatcher
import org.krypsis.symbian.http.InvalidKrypsisRequestException
import org.krypsis.http.request.Request

scenario "a valid http request is given", {

  given "the default request matcher", {
    namespace = Request.NAMESPACE
    matcher = new DefaultRequestMatcher();
  }

  when "valid request are given", {
    requests = [
            "m/a",
            "module/action",
            "module/action?param",
            "module/action?param=",
            "module/action?param=value",
            "module/action?param=value&param2=",
            "module/action?param=value&param2=value2",
            "module/action?param=value&param2=value2&param3=%20%d0"
    ]
  }

  then "each request match the pattern", {
    requests.each { request ->
      result = matcher.match("GET $namespace$request HTTP/1.1")
      result.shouldBe "$namespace$request"
    }
  }
}

scenario "some invalid requests are given", {

  given "the default request matcher", {
    namespace = Request.NAMESPACE
    matcher = new DefaultRequestMatcher();
  }

  when "valid request are given", {
    requests = [
            "${namespace}module/action?",
            "PUT ${namespace}module/module2/action HTTP",
            "GET ${namespace}m/a",
            " GET ${namespace}m/a",
            " GET ${namespace}m/a HTTP",
            " GET ${namespace}m/a HTTP ",
            "POST ${namespace}module",
            "PUT${namespace}module/action?param",
            "PUT ${namespace}module/action? p ",
            "PUT org/krypsis/device/module/action/ HTTP",
            "PUT org/krypsis/device/module_action/ HTTP",
    ]
  }

  then "each request does not match the pattern", {
    requests.each { request ->
      ensureThrows(InvalidKrypsisRequestException.class) {
        matcher.match(request)
      }
    }
  }
}