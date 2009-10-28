import org.krypsis.util.Identity

scenario "Generate an ascii range", {

  given "the identity instance", {
    identity = Identity.instance
  }

  when "char range schould be generated", {
    range = identity.getCharacterRange(48, 57)
  }

  then "range should be 0..9", {
    range.shouldBe ('0'..'9')
  }
}

scenario "two char arrays should be merged", {

  given "two char arrays and the identity instance", {
    identity = Identity.instance
    array1 = ('0'..'9')
    array2 = ('a'..'z')
  }

  when "array is merged", {
    array = identity.merge((char[]) array1, (char[]) array2)
  }

  then "array consists of the both given arrays", {
    array.shouldBe (array1 + array2)
  }
}

scenario "generate a random string of the specified length", {

  given "the identity instance", {
    identity = Identity.instance
  }

  when "the string is generated", {
    string = identity.getRandomString(40)
  }

  then "the length schould be 40", {
    string.size().shouldBe 40
  }

  and "the string contains only alphanumeric values", {
    string.matches("[a-zA-Z0-9]{40}").shouldBe true
  }
}

scenario "Generate a new id", {

  given "the identity instance and a date", {
    date = new Date()
    identity = Identity.instance
  }

  when "a new id is generated", {
    id = identity.generate(date)
  }

  then "it should start with a string of 32 chars", {
    id[0..31].matches("[a-zA-Z0-9]{32}").shouldBe true
  }

  and "it should have an @ sign in it", {
    id[32].shouldBe "@"
  }

  and "should be follwed by a timestamp", {
    id[33..-1].shouldBeEqual date.time.toString()
    println id
  }
}