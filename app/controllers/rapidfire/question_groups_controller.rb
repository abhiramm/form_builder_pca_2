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
      @question_group.save
      puts "##################{rapidfire.question_groups_url}###########"
      puts "##################{request.remote_ip}###########"

      respond_with(@question_group, location: rapidfire.question_groups_url)
#      if Rails.env == "production" 
 #       respond_with(@question_group, location: "http://107.170.67.113/course_forms/question_groups/#{@question_group.id}/answer_groups/new")
#    else
 #       respond_with(@question_group, location: "http://localhost:3000/course_forms/question_groups/#{@question_group.id}/answer_groups/new")
#    end
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
        params.require(:question_group).permit(:name)
      else
        params[:question_group]
      end
    end
  end
end
