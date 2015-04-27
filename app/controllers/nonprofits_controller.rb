class NonprofitsController < ApplicationController
  autocomplete :nonprofit, :name, :full => true
end