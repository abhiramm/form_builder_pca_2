module Rapidfire
        class QuestionGroupsController < Rapidfire::ApplicationController
                before_filter :authenticate_administrator!, except: :index
                respond_to :html, :js
                respond_to :json, only: :results
                  authorize_actions_for :question_group_class, actions: { result: 'read'}
                 def question_group_class
                  [QuestionGroup, {model: "forms"}]
                 end

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
                        @question_group.child_id = params[:child_id]
                        course_fees = params[:question_group][:amount].to_f
                        puts "course_fee #{course_fees}"

                        admin_comm = 2.75
                        stripe_comm = ((course_fees + admin_comm) * 2.9/100) + 0.30
                        puts "stripe commission: #{stripe_comm}"
                        total_amount = course_fees + admin_comm + stripe_comm
                        @question_group.admin_comm = admin_comm
                        @question_group.stripe_comm = stripe_comm
                        @question_group.total_amount = total_amount
                        Rails.logger.info "################________________________question_groups in params #{params[:question_group]}"
			if params[:form_type] == "ir"
				@question_group.name = "Incident Report: #{params[:question_group][:name]}"
			Rails.logger.info "question_groupppppppppppppppppppppp #{@question_group.name}"
			end
			@question_group.save
			params[:classes].each do |c|
                         FormStage.create(:question_group_id => @question_group.id, :stage => c)
			end
			#Rails.logger.info "Form class saved #{fc}"
                        Rails.logger.info "#{@question_group}"
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
                                params.require(:question_group).permit(:name, :description, :day_care_id, :form_type, :amount, :is_saved, :is_published, :published_at, :stripe_comm, :admin_comm, :total_amount)
                        else
                                params[:question_group]
                        end
                end
        end
end
