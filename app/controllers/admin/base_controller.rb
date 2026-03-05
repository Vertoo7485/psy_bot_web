class Admin::BaseController < ApplicationController
  include AdminConcern
  layout 'admin'
end
