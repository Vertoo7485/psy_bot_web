// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import DayProgramController from "./day_program_controller"
application.register("day-program", DayProgramController)
import TestController from "./test_controller"
application.register("test", TestController)
