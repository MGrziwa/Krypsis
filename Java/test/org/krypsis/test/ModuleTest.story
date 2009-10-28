import org.krypsis.module.Module
import org.krypsis.module.RootApplication
import org.krypsis.module.ModuleContext
import org.krypsis.module.Command
import org.krypsis.http.request.Requestable
import org.krypsis.http.response.ResponseDispatchable
import org.krypsis.module.ModuleListener

scenario "new command should be registered", {

  given "the new base module", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
  }

  when "a new command is added", {
    module.registerCommand("command", TestCommand.class)
  }

  then "a new command is registered", {
    module.commands.command.shouldBe TestCommand.class
  }
}

scenario "memorize duplicate key", {

  given "the module", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
  }

  when "put a key value pair to scope", {
    module.put "key", "value"
  }

  and "put the same again", {
    result = {
      module.put "key", "value"
    }
  }

  then "an exception has to be thrown", {
    ensureThrows(IllegalArgumentException.class) {
      result()
    }
  }
}

scenario "a new command should be created from action name", {

  given "action name and module", {
    name = "action"
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
    module.registerCommand(name, TestCommand.class)
  }

  when "get command is called", {
    result = module.getCommand(name)
  }

  then "the result must not be null", {
    result.shouldNotBe null
  }

  and "the result should be an instance of the command class", {
    result.class.shouldBe TestCommand.class
  }

}

scenario "handle gets null values", {

  given "module", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)    
  }

  when "call handle with null", {
    values = [
            [null, null],
            [null, [:] as ResponseDispatchable],
            [[:] as Requestable, null],
    ]
  }

  then "a null pointer exception is thrown", {
    values.each { array ->
      ensureThrows(NullPointerException.class) {
        module.handle(array[0], array[1])
      }
    }
  }
}

scenario "add and remove module listeners", {

  given "module and listener", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
    destroyed = false
    listener = [onDestroy: { destroyed = true }, toString: { "Listener" }] as ModuleListener
  }

  when "a listener is added", {
    module.addModuleListener(listener)
  }

  then "listener size is 1", {
    module.moduleListeners.size().shouldBe 1
  }

  when "the listener is removed", {
    module.removeModuleListener(listener)
  }

  then "listener size is 0", {
    module.moduleListeners.size().shouldBe 0
  }

  and "destroyed was called on module", {
    destroyed.shouldBe true
  }
}

scenario "module listeners are added and module should be destroyed", {

  given "module and listeners", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
    count = 0

    10.times {
      listener = [onDestroy: { count += 1 }, toString: { "Listener" }]
      module.addModuleListener(listener as ModuleListener)
    }
  }

  when "the module destroy method is called", {
    module.destroy()
  }

  then "listener size is 0", {
    module.moduleListeners.size().shouldBe 0
  }

  and "onDestroy was called 10 times", {
    count.shouldBe 10
  }
}


class TestCommand implements Command {
  public void execute(Module module, Requestable request, ResponseDispatchable dispatchable) {}
}