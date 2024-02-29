require 'json'

class FeedbackLoop
  def initialize(feedback_file)
    @feedback_file = feedback_file
    load_feedback
  end

  def add_feedback(query, document_id, relevance)
    @feedback[query] ||= {}
    @feedback[query][document_id] = relevance
    save_feedback
  end

  def get_feedback(query)
    @feedback[query] || {}
  end

  private

  def load_feedback
    @feedback = JSON.parse(File.read(@feedback_file)) if File.exist?(@feedback_file)
    @feedback ||= {}
  end

  def save_feedback
    File.write(@feedback_file, JSON.generate(@feedback))
  end
end

# Example usage
feedback_loop = FeedbackLoop.new('feedback.json')
query = 'machine learning'
document_id = 'doc123'
relevance = 1
feedback_loop.add_feedback(query, document_id, relevance)

# Get feedback for a query
p feedback_loop.get_feedback('machine learning')
