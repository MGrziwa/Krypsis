import org.krypsis.module.RootApplication
import org.krypsis.module.Module
import org.krypsis.module.ModuleContext
import org.krypsis.module.ModuleRegistry
import org.krypsis.module.ModuleListener

scenario "add and retrieve modules", {

  given "new module", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
    registry = ModuleRegistry.getInstance()
  }

  when "this module is added to the registry", {
    registry.register(module)
  }

  and "the module is requested by context", {
    result = registry.getModule(ModuleContext.BASE)
  }

  then "the result is the previously defined module", {
    result.shouldBe module
  }
}

scenario "register and unregister modules", {

  given "new module and registry", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)
    registry = ModuleRegistry.getInstance()
  }

  when "module is registered", {
    registry.register(module)
  }

  then "the module can be retrieved by the context", {
    result = registry.getModule(ModuleContext.BASE)
    result.shouldBe module
  }

  when "module is unregistered", {
    registry.unregister(module)
  }

  then "the returned result is null", {
    result = registry.getModule(ModuleContext.BASE)
    result.shouldBe null
  }
}

scenario "registered module should be removed", {

  given "module and registry", {
    app = [:] as RootApplication

    destroyed = false
    module = new Module(app, ModuleContext.BASE)
    
    registry = ModuleRegistry.getInstance()
    registry.register(module)
  }

  when "unregister module", {
    ensure(registry.modules.size() == 1) { isTrue }
    registry.unregister(module)
  }

  then "destroyed was called on module", {
    registry.modules.size().shouldEqual 0
  }
}

scenario "reset the module registry",  {

  given "the registry", {
    app = [:] as RootApplication
    module = new Module(app, ModuleContext.BASE)

    registry = ModuleRegistry.getInstance()
    registry.register(module)
  }

  when "a listener is registered", {
    module.addModuleListener([toString: { "ML" }, onDestroy: { }] as ModuleListener)
  }

  and "add something to the scope", {
    module.put("key", "value")
  }

  then "the scope should contains a value", {
    module.get('key').shouldEqual "value"
  }

  and "the listeners count should be 1", {
    module.moduleListeners.size().shouldEqual 1
  }

  when "reset the module registry", {
    registry.reset()
  }

  then "scope must be empty", {
    module.scope.size().shouldEqual 0
  }

  and "listener must be removed", {
    module.moduleListeners.size().shouldEqual 0
  }
}