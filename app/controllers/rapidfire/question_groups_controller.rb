module Rapidfire
  class QuestionGroupsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index
    respond_to :html, :js
    respond_to :json, only: :results

    def index
      @question_groups = QuestionGroup.all
      respond_with(@question_groups)
    end

    def new
      @question_group = QuestionGroup.new
      respond_with(@question_group)
    end

    def create
      @question_group = QuestionGroup.new(question_group_params)
      @question_group.day_care_id = params[:day_care_id]
      @question_group.form_type = params[:form_type]
      @question_group.save
      
      puts "##################{rapidfire.question_groups_url}###########"
      puts "##################{request.remote_ip}###########"

     # respond_with(@question_group, location: rapidfire.question_groups_url)
      if Rails.env == "production" 
        respond_with(@question_group, location: "http://app.parentsconnectapp.com/course_forms/question_groups/#{@question_group.id}/questions/new")
      else
        respond_with(@question_group, location: "http://localhost:3000/course_forms/question_groups/#{@question_group.id}/questions/new")
      end
    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy

      respond_with(@question_group)
    end

    def results
      @question_group = QuestionGroup.find(params[:id])
      @question_group_results =
        QuestionGroupResults.new(question_group: @question_group).extract

      respond_with(@question_group_results, root: false)
    end

    private
    def question_group_params
      if Rails::VERSION::MAJOR == 4
        params.require(:question_group).permit(:name, :description, :day_care_id, :form_type, :amount)
      else
        params[:question_group]
      end
    end
  end
end
