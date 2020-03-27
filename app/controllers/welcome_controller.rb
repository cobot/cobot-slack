# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate
  before_action :show_header

  def show; end
end
