/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bean;


public class FlashcardDetailBean {
    private int flashcardId;
    private String question;
    private String answer;

    // Constructor mặc định
    public FlashcardDetailBean() {
    }

    // Getter và Setter
    public int getFlashcardId() {
        return flashcardId;
    }

    public void setFlashcardId(int flashcardId) {
        this.flashcardId = flashcardId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    @Override
    public String toString() {
        return "FlashcardBean{"
                + "flashcardId=" + flashcardId
                + ", question='" + question + '\''
                + ", answer='" + answer + '\''
                + '}';
    }
}
