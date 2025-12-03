# frozen_string_literal: true

module EventStoreTestHelper
  # Returns an in-memory event store for testing
  # This is faster than using the database-backed event store
  def in_memory_repository
    @in_memory_repository ||= RubyEventStore::InMemoryRepository.new
  end

  # Returns a fresh event store client for each test
  def event_store
    @event_store ||= RailsEventStore::Client.new(repository: in_memory_repository)
  end

  # Reads all events from the event store
  def read_all_events
    event_store.read.stream("all").to_a
  end

  # Reads events from a specific stream
  def read_stream_events(stream_name)
    event_store.read.stream(stream_name).to_a
  end

  # Asserts that an event of the given type was published
  def assert_event_published(event_type, stream_name: nil, data: nil)
    events = stream_name ? read_stream_events(stream_name) : read_all_events
    matching_events = events.select { |e| e.class == event_type }

    assert matching_events.any?, "Expected #{event_type} to be published, but it wasn't"

    if data
      # Normalize both hashes to symbol keys for comparison
      normalized_data = normalize_hash_keys(data)
      matching_event = matching_events.find do |e|
        normalized_event_data = normalize_hash_keys(e.data)
        normalized_event_data == normalized_data
      end
      assert matching_event, "Expected #{event_type} with data #{data}, but found #{matching_events.map(&:data)}"
    end

    matching_events.first
  end

  # Asserts that no event of the given type was published
  def assert_no_event_published(event_type, stream_name: nil)
    events = stream_name ? read_stream_events(stream_name) : read_all_events
    matching_events = events.select { |e| e.class == event_type }

    assert matching_events.empty?,
      "Expected no #{event_type} to be published, but found #{matching_events.count}"
  end

  # Asserts that exactly N events of the given type were published
  def assert_events_published(event_type, count:, stream_name: nil)
    events = stream_name ? read_stream_events(stream_name) : read_all_events
    matching_events = events.select { |e| e.class == event_type }

    assert_equal count, matching_events.count,
      "Expected #{count} #{event_type} events, but found #{matching_events.count}"
  end

  # Clears all events from the test event store
  def clear_event_store
    in_memory_repository.reset
  end

  private

    # Normalizes hash keys to symbols for consistent comparison
    def normalize_hash_keys(hash)
      hash.each_with_object({}) do |(key, value), normalized|
        normalized_key = key.is_a?(String) ? key.to_sym : key
        normalized[normalized_key] = value
      end
    end
end

