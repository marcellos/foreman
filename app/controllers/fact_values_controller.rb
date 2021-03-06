class FactValuesController < ApplicationController
  before_filter :require_ssl, :except => :create
  before_filter :require_login, :except => :create
  before_filter :verify_authenticity_token, :except => :create

  # avoids storing the facts data in the log files
  filter_parameter_logging :facts

  def index
    @search      = FactValue.search(params[:search])
    @fact_values = @search.paginate :page => params[:page], :include => [:fact_name, { :host => :domain }]
    @via         = ""
  end

  def create
    respond_to do |format|
      format.yml {
        if Host.importHostAndFacts params.delete("facts")
          render :text => "Imported facts", :status => 200 and return
        else
          render :text => "Failed to import facts", :status => 500
        end
      }
    end
  end

end
