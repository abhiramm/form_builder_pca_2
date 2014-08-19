module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!
    respond_to :html, :js

    before_filter :find_question_group!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @question_group.questions
      respond_with(@questions)
    end

    def new
      @question = QuestionForm.new(:question_group => @question_group)
      @question_group = QuestionGroup.find(params[:question_group_id])
      # To bring form show page in add field page
      answer_params = {}
      answer_params[:user] = current_user
      answer_params[:question_group] = @question_group
      puts "Answer_params in questions #{answer_params}"
      @answer_group_builder = AnswerGroupBuilder.new(answer_params)
      respond_with(@question)
    end
    # To bring form show page in add field page 
    
    def create
      form_params = params[:question].merge(:question_group => @question_group)
      @question = QuestionForm.new(form_params)
      @question.save
      
    #  respond_with(@question, location: index_location)
      if Rails.env == "production" 
        respond_with(@question_group, location: "http://app.parentsconnectapp.com/course_forms/question_groups/#{@question_group.id}/questions/new")
      else
        respond_with(@question_group, location: "http://localhost:3000/course_forms/question_groups/#{@question_group.id}/questions/new")
      end
 
    end

    def edit
      @question = QuestionForm.new(:question => @question)
      respond_with(@question)
    end

    def update
      form_params = params[:question].merge(:question => @question)
      @question = QuestionForm.new(form_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def destroy
      @question.destroy
      respond_with(@question, location: index_location)
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def find_question!
      @question = @question_group.questions.find(params[:id])
    end

    def index_location
      rapidfire.question_group_questions_url(@question_group)
    end
  end
end
