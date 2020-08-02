require './config/environment'



use Rack::MethodOverride
use ServiceController
use ClientController
use ProviderController
use AppointmentController
run ApplicationController
