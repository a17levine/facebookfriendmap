class EntranceProcessor
  include Sidekiq::Worker

  def process
    puts 'Doing hard work'
  end
end