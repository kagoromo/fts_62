class Admins::ExamsController < ApplicationController
  load_and_authorize_resource

  def index
    @subjects = Subject.all
    @statuses = Exam.statuses
    @search = @exams.ransack params[:q]
    @exams = @search.result unless params[:q].nil?
    @exams = @exams.page(params[:page]).per(Settings.exam.per_page).
      order created_at: :desc
  end

  def edit
  end

  def update
    if @exam.update_attributes exam_params
      @exam.update_attributes score: @exam.calculated_score
      @exam.send_score_to_chatwork current_admin
      flash[:success] = t "exam.check_done"
      redirect_to admins_exams_path
    else
      flash[:success] = t "exam.check_fail"
      render "edit"
    end
  end

  private
  def exam_params
    params.require(:exam).permit :status,
      results_attributes: [:id, :is_correct]
  end
end
