require "rails_helper"

RSpec.describe Admins::ExamsController, type: :controller do
  let(:admin) {create :admin}
  before {sign_in admin}

  describe "GET #index" do
    it "populates arrays of subjects and exams" do
      subject = create :subject
      other_subject = create :subject
      exam = create :exam, subject: subject
      other_exam = create :exam, subject: other_subject
      get :index
      expect(assigns :subjects).to match_array [subject, other_subject]
      expect(assigns :exams).to match_array [exam, other_exam]
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #edit" do
    let(:exam) {create :exam}

    it "locates the requested exam" do
      get :edit, id: exam
      expect(assigns :exam).to eq exam
    end

    it "render the :edit template" do
      get :edit, id: exam
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    let(:exam) {create :exam}
    let(:mock_exam) {double "exam"}

    it "locates the requested exam" do
      patch :update, id: exam, exam: attributes_for(:exam)
    end

    context "valid attributes" do
      it "changes exam's attributes" do
        patch :update, id: exam, exam: attributes_for(:exam,
          status: Settings.exam.checked)
        exam.reload
        expect(exam.status).to eq Settings.exam.checked
      end

      it "redirects to admins/exam#index" do
        patch :update, id: exam, exam: attributes_for(:exam)
        expect(response).to redirect_to admins_exams_path
      end
    end

    context "with invalid attributes" do
      it "does not change the exam's attributes" do
        patch :update, id: exam, exam: attributes_for(:exam_not_enough_questions)
        expect{exam.reload}.not_to change {exam.subject}
      end

      it "renders the :edit template again" do
        allow(Exam).to receive(:find).and_return(mock_exam)
        allow(mock_exam).to receive(:update_attributes).and_return false
        patch :update, id: mock_exam, exam: attributes_for(:exam)
        expect(response).to render_template :edit
      end
    end
  end
end
