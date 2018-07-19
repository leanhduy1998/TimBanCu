-- Build everything from scratch

DROP TABLE IF EXISTS block_list;
CREATE TABLE "block_list" (
  user_id TEXT NOT NULL,
  synced_at DATETIME,
  unblocked_at DATETIME
);

DROP TABLE IF EXISTS conversation_participants;
CREATE TABLE "conversation_participants" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  conversation_database_identifier INTEGER NOT NULL,
  stream_member_database_identifier INTEGER,
  member_id TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  deleted_at DATETIME,
  seq INTEGER,
  event_database_identifier INTEGER UNIQUE,
  marked_as_read_position INTEGER,
  marked_as_read_seq INTEGER,
  UNIQUE(conversation_database_identifier, member_id),
  FOREIGN KEY(conversation_database_identifier) REFERENCES conversations(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(event_database_identifier) REFERENCES events(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS conversations;
CREATE TABLE "conversations" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  stream_database_identifier INTEGER UNIQUE,
  stream_id BLOB UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  object_identifier TEXT UNIQUE NOT NULL,
  version INT NOT NULL,
  has_unread_messages INTEGER NOT NULL DEFAULT 0,
  is_distinct INTEGER NOT NULL DEFAULT 0,
  type INTEGER NOT NULL DEFAULT 1,
  deletion_mode INTEGER DEFAULT 0,
  total_message_count INTEGER NOT NULL DEFAULT 0,
  unread_message_count INTEGER NOT NULL DEFAULT 0,
  participants_hash TEXT,
  read_receipts_enabled BOOLEAN DEFAULT 1
);

DROP TABLE IF EXISTS deleted_message_parts;
CREATE TABLE "deleted_message_parts" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  file_path TEXT
);

DROP TABLE IF EXISTS event_content_parts;
CREATE TABLE "event_content_parts" (
  database_identifier INTEGER PRIMARY KEY AUTOINCREMENT,
  event_content_part_id INTEGER NOT NULL,
  event_database_identifier INTEGER NOT NULL,
  type TEXT NOT NULL,
  value BLOB,
  access_expiration INTEGER,
  url TEXT,
  size INTEGER,
  transfer_status INTEGER,
  file_path TEXT,
  last_accessed DATETIME,
  purged BOOLEAN,
  client_id BLOB,
  FOREIGN KEY(event_database_identifier) REFERENCES events(database_identifier) ON DELETE CASCADE,
  UNIQUE(event_content_part_id, event_database_identifier)
);

DROP TABLE IF EXISTS events;
CREATE TABLE "events" (
  database_identifier INTEGER PRIMARY KEY AUTOINCREMENT,
  type INTEGER NOT NULL,
  creator_id TEXT,
  seq INTEGER,
  timestamp INTEGER,
  preceding_seq INTEGER,
  client_seq INTEGER NOT NULL,
  subtype INTEGER,
  external_content_id BLOB,
  member_id TEXT,
  target_seq INTEGER,
  stream_database_identifier INTEGER NOT NULL,
  client_id BLOB, creator_name TEXT,
  deletion_mode INTEGER DEFAULT 0,
  target_position INTEGER,
  UNIQUE(stream_database_identifier, seq),
  FOREIGN KEY(stream_database_identifier) REFERENCES streams(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS fts_trigger_mime_type_mapping;
CREATE TABLE "fts_trigger_mime_type_mapping" (
	database_identifier INTEGER PRIMARY KEY AUTOINCREMENT,
	mime_type TEXT NOT NULL,
	fts_trigger_name TEXT UNIQUE NOT NULL
);

DROP TABLE IF EXISTS identities;
CREATE TABLE "identities" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  object_identifier TEXT NOT NULL,
  user_id TEXT,
  display_name TEXT,
  first_name TEXT,
  last_name TEXT,
  email_address TEXT,
  phone_number TEXT,
  avatar_image_url TEXT,
  public_key TEXT,
  followed BOOLEAN NOT NULL DEFAULT 0,
  should_follow INTEGER NOT NULL DEFAULT 0,
  version INTEGER NOT NULL,
  deleted_at DATETIME,
  presence_status INTEGER NOT NULL DEFAULT 0,
  last_seen_at DATETIME,
  UNIQUE(database_identifier)
);

DROP TABLE IF EXISTS local_keyed_values;
CREATE TABLE "local_keyed_values" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  object_type TEXT NOT NULL,
  object_id INTEGER NOT NULL,
  key_type INTEGER NOT NULL,
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  deleted_at DATETIME,
  timestamp INTEGER,
  UNIQUE(object_type, object_id, key)
);

DROP TABLE IF EXISTS message_parts;
CREATE TABLE "message_parts" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  message_database_identifier INTEGER NOT NULL,
  mime_type TEXT NOT NULL,
  content BLOB,
  url TEXT,
  access_expiration INTEGER,
  file_path TEXT,
  size INTEGER,
  access_time DATETIME,
  object_identifier TEXT,
  pruned BOOLEAN,
  transfer_status INTEGER,
  version INT NOT NULL DEFAULT 0,
  updated_at DATETIME,
  event_seq INTEGER,
  FOREIGN KEY(message_database_identifier) REFERENCES messages(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS message_recipient_status;
CREATE TABLE "message_recipient_status" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  message_database_identifier INTEGER NOT NULL,
  user_id TEXT,
  status INTEGER NOT NULL,
  seq INTEGER,
  UNIQUE (message_database_identifier, user_id, status),
  FOREIGN KEY(message_database_identifier) REFERENCES messages(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS messages;
CREATE TABLE "messages" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sent_at DATETIME,
  received_at DATETIME,
  deleted_at DATETIME,
  user_id TEXT,
  seq INTEGER,
  conversation_database_identifier INTEGER NOT NULL,
  event_database_identifier INTEGER UNIQUE,
  version INTEGER NOT NULL,
  object_identifier TEXT UNIQUE NOT NULL,
  message_index INTEGER,
  is_unread INTEGER NOT NULL DEFAULT 0,
  user_name TEXT,
  type INTEGER NOT NULL DEFAULT 1,
  deletion_mode INTEGER DEFAULT 0,
  UNIQUE(conversation_database_identifier, seq),
  FOREIGN KEY(conversation_database_identifier) REFERENCES conversations(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(event_database_identifier) REFERENCES events(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS mutations;
CREATE TABLE "mutations" (
  database_identifier INTEGER PRIMARY KEY AUTOINCREMENT,
  seq INTEGER,
  type INTEGER NOT NULL,
  target INTEGER NOT NULL,
  stream_id BLOB NOT NULL,
  target_seq INTEGER NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  stream_database_identifier,
  event_database_identifier,
  is_synchronized BOOL,
  FOREIGN KEY(stream_database_identifier) REFERENCES streams(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS mutations_sequence;
CREATE TABLE "mutations_sequence" (
  identity_sequence INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS remote_keyed_values;
CREATE TABLE "remote_keyed_values" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  object_type TEXT NOT NULL,
  object_id INTEGER NOT NULL,
  key_type INTEGER NOT NULL,
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  deleted_at DATETIME,
  timestamp INTEGER,
  UNIQUE(object_type, object_id, key)
);

DROP TABLE IF EXISTS schema_migrations;
CREATE TABLE schema_migrations (
  version INTEGER UNIQUE NOT NULL
);

DROP TABLE IF EXISTS stream_members;
CREATE TABLE "stream_members" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  stream_database_identifier INTEGER NOT NULL,
  member_id TEXT NOT NULL,
  deleted_at DATETIME,
  seq INTEGER,
  UNIQUE (stream_database_identifier, member_id),
  FOREIGN KEY(stream_database_identifier) REFERENCES streams(database_identifier) ON DELETE CASCADE
);

DROP TABLE IF EXISTS streams;
CREATE TABLE "streams" (
  database_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  stream_id BLOB UNIQUE,
  seq INTEGER NOT NULL DEFAULT 0,
  client_seq INTEGER NOT NULL DEFAULT 0,
  client_id BLOB,
  deleted_at DATETIME,
  min_synced_seq INTEGER,
  max_synced_seq INTEGER,
  metadata_timestamp INTEGER,
  is_distinct INTEGER NOT NULL DEFAULT 0,
  type INTEGER NOT NULL DEFAULT 1,
  total_message_event_count INTEGER NOT NULL DEFAULT 0,
  unread_message_event_count INTEGER NOT NULL DEFAULT 0,
  least_recent_unread_message_event_seq INTEGER,
  last_message_event_received_at DATETIME,
  last_message_event_seq INTEGER,
  deletion_mode INTEGER DEFAULT 0,
  starting_seq INTEGER,
  mutation_seq INTEGER,
  created_at DATETIME,
  members_hash TEXT,
  name TEXT
);

DROP TABLE IF EXISTS syncable_changes;
CREATE TABLE "syncable_changes" (
  change_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  table_name TEXT NOT NULL,
  row_identifier INTEGER NOT NULL,
  change_type INTEGER NOT NULL
);

DROP TABLE IF EXISTS synced_changes;
CREATE TABLE "synced_changes" (
  change_identifier INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  change_type INTEGER NOT NULL,
  stream_database_identifier INTEGER,
  mutation_database_identifier INTEGER,
  event_database_identifier INTEGER,
  event_content_part_database_identifier INTEGER,
  remote_keyed_value_database_identifier INTEGER,
  stream_member_database_identifier INTEGER,
  associated_stream_database_identifier INTEGER NOT NULL,
  FOREIGN KEY(stream_database_identifier) REFERENCES streams(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(mutation_database_identifier) REFERENCES mutations(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(event_database_identifier) REFERENCES events(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(event_content_part_database_identifier) REFERENCES event_content_parts(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(remote_keyed_value_database_identifier) REFERENCES remote_keyed_values(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(stream_member_database_identifier) REFERENCES stream_members(database_identifier) ON DELETE CASCADE,
  FOREIGN KEY(associated_stream_database_identifier) REFERENCES streams(database_identifier) ON DELETE CASCADE
);

DROP INDEX IF EXISTS block_list_user_id_idx;
CREATE INDEX block_list_user_id_idx ON block_list(user_id);

DROP INDEX IF EXISTS conversation_participants_conversation_database_identifier_idx;
CREATE INDEX conversation_participants_conversation_database_identifier_idx ON conversation_participants(conversation_database_identifier);

DROP INDEX IF EXISTS conversation_participants_deleted_at_idx;
CREATE INDEX conversation_participants_deleted_at_idx ON conversation_participants(deleted_at);

DROP INDEX IF EXISTS conversation_participants_event_database_identifier_idx;
CREATE INDEX conversation_participants_event_database_identifier_idx ON conversation_participants(event_database_identifier);

DROP INDEX IF EXISTS conversations_deleted_at_idx;
CREATE INDEX conversations_deleted_at_idx ON conversations(deleted_at);

DROP INDEX IF EXISTS conversations_deletion_mode_idx;
CREATE INDEX conversations_deletion_mode_idx ON conversations(deletion_mode);

DROP INDEX IF EXISTS conversations_has_unread_messages_idx;
CREATE INDEX conversations_has_unread_messages_idx ON conversations(has_unread_messages);

DROP INDEX IF EXISTS conversations_object_identifier_idx;
CREATE INDEX conversations_object_identifier_idx ON conversations(object_identifier);

DROP INDEX IF EXISTS conversations_stream_database_identifier_idx;
CREATE INDEX conversations_stream_database_identifier_idx ON conversations(stream_database_identifier);

DROP INDEX IF EXISTS conversations_type_idx;
CREATE INDEX conversations_type_idx ON conversations(type);

DROP INDEX IF EXISTS events_client_id_idx;
CREATE INDEX events_client_id_idx ON events(client_id);

DROP INDEX IF EXISTS events_seq_idx;
CREATE INDEX events_seq_idx ON events(seq);

DROP INDEX IF EXISTS events_stream_database_identifier_idx;
CREATE INDEX events_stream_database_identifier_idx ON events(stream_database_identifier);

DROP INDEX IF EXISTS identities_user_id_idx;
CREATE INDEX identities_user_id_idx ON identities(user_id);

DROP INDEX IF EXISTS message_recipient_status_message_database_identifier_idx;
CREATE INDEX message_recipient_status_message_database_identifier_idx ON message_recipient_status(message_database_identifier);

DROP INDEX IF EXISTS messages_conversation_database_identifier_idx;
CREATE INDEX messages_conversation_database_identifier_idx ON messages(conversation_database_identifier);

DROP INDEX IF EXISTS messages_conversationdbid_and_isunread_idx;
CREATE INDEX messages_conversationdbid_and_isunread_idx ON messages(conversation_database_identifier, is_unread);

DROP INDEX IF EXISTS messages_deleted_at_idx;
CREATE INDEX messages_deleted_at_idx ON messages(deleted_at);

DROP INDEX IF EXISTS messages_deletion_mode_idx;
CREATE INDEX messages_deletion_mode_idx ON messages(deletion_mode);

DROP INDEX IF EXISTS messages_event_database_identifier_idx;
CREATE INDEX messages_event_database_identifier_idx ON messages(event_database_identifier);

DROP INDEX IF EXISTS messages_is_unread_idx;
CREATE INDEX messages_is_unread_idx ON messages(is_unread);

DROP INDEX IF EXISTS messages_message_index_idx;
CREATE INDEX messages_message_index_idx ON messages(message_index);

DROP INDEX IF EXISTS messages_object_identifier_idx;
CREATE INDEX messages_object_identifier_idx ON messages(object_identifier);

DROP INDEX IF EXISTS messages_type_idx;
CREATE INDEX messages_type_idx ON messages(type);

DROP INDEX IF EXISTS stream_members_deleted_at_idx;
CREATE INDEX stream_members_deleted_at_idx ON stream_members(deleted_at);

DROP INDEX IF EXISTS stream_members_stream_database_identifier_idx;
CREATE INDEX stream_members_stream_database_identifier_idx ON stream_members(stream_database_identifier);

DROP INDEX IF EXISTS streams_client_id_idx;
CREATE INDEX streams_client_id_idx ON streams(client_id);

DROP INDEX IF EXISTS streams_deleted_at_idx;
CREATE INDEX streams_deleted_at_idx ON streams(deleted_at);

DROP INDEX IF EXISTS streams_deletion_mode_idx;
CREATE INDEX streams_deletion_mode_idx ON streams(deletion_mode);

DROP INDEX IF EXISTS streams_type_idx;
CREATE INDEX streams_type_idx ON streams(type);

DROP INDEX IF EXISTS synced_changes_associated_stream_db_id_idx;
CREATE INDEX synced_changes_associated_stream_db_id_idx ON synced_changes(associated_stream_database_identifier);

DROP INDEX IF EXISTS synced_changes_event_content_part_db_id_idx;
CREATE INDEX synced_changes_event_content_part_db_id_idx ON synced_changes(event_content_part_database_identifier);

DROP INDEX IF EXISTS synced_changes_event_db_id_idx;
CREATE INDEX synced_changes_event_db_id_idx ON synced_changes(event_database_identifier);

DROP INDEX IF EXISTS synced_changes_mutation_db_id_idx;
CREATE INDEX synced_changes_mutation_db_id_idx ON synced_changes(mutation_database_identifier);

DROP INDEX IF EXISTS synced_changes_remote_keyed_value_db_id_idx;
CREATE INDEX synced_changes_remote_keyed_value_db_id_idx ON synced_changes(remote_keyed_value_database_identifier);

DROP INDEX IF EXISTS synced_changes_stream_db_id_idx;
CREATE INDEX synced_changes_stream_db_id_idx ON synced_changes(stream_database_identifier);

DROP INDEX IF EXISTS synced_changes_stream_member_db_id_idx;
CREATE INDEX synced_changes_stream_member_db_id_idx ON synced_changes(stream_member_database_identifier);

DROP TRIGGER IF EXISTS tombstone_duplicate_events_by_client_id;
CREATE TRIGGER tombstone_duplicate_events_by_client_id
AFTER INSERT ON events
FOR EACH ROW WHEN NEW.client_id IS NOT NULL
BEGIN
  UPDATE events SET type = 10
  WHERE database_identifier = NEW.database_identifier
  AND (SELECT count(*) FROM events WHERE client_id = NEW.client_id) > 1;
END;

DROP TRIGGER IF EXISTS track_deletes_of_conversation_participants;
CREATE TRIGGER track_deletes_of_conversation_participants AFTER UPDATE OF deleted_at ON conversation_participants
WHEN NEW.seq IS OLD.seq AND (NEW.deleted_at NOT NULL AND OLD.deleted_at IS NULL)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversation_participants', NEW.database_identifier, 2);
END;

DROP TRIGGER IF EXISTS track_deletes_of_local_keyed_values;
CREATE TRIGGER track_deletes_of_local_keyed_values AFTER UPDATE OF deleted_at ON local_keyed_values
WHEN NEW.timestamp IS NULL AND (NEW.deleted_at NOT NULL AND OLD.deleted_at IS NULL)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('local_keyed_values', NEW.database_identifier, 2);
END;

DROP TRIGGER IF EXISTS track_deletes_of_remote_keyed_values;
CREATE TRIGGER track_deletes_of_remote_keyed_values AFTER UPDATE OF deleted_at ON remote_keyed_values
WHEN NEW.timestamp NOT NULL AND (NEW.deleted_at NOT NULL AND OLD.deleted_at IS NULL)
BEGIN
  INSERT INTO synced_changes(remote_keyed_value_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD.database_identifier, 2, OLD.object_id);
END;

DROP TRIGGER IF EXISTS track_deletes_of_stream_members;
CREATE TRIGGER track_deletes_of_stream_members AFTER UPDATE OF deleted_at ON stream_members
WHEN NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL
BEGIN
  INSERT INTO synced_changes(stream_member_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD._ROWID_, 2, OLD.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_deletes_of_streams;
CREATE TRIGGER track_deletes_of_streams AFTER UPDATE OF deletion_mode ON streams
WHEN NEW.deletion_mode = 2
BEGIN
  INSERT INTO synced_changes(stream_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD.database_identifier, 2, OLD.database_identifier);
END;

DROP TRIGGER IF EXISTS track_deletions_of_conversations;
CREATE TRIGGER track_deletions_of_conversations AFTER UPDATE OF deletion_mode ON conversations
WHEN NEW.deletion_mode != 0
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversations', NEW.database_identifier, 2);
END;

DROP TRIGGER IF EXISTS track_event_content_part_purges;
CREATE TRIGGER track_event_content_part_purges AFTER UPDATE OF transfer_status ON event_content_parts
WHEN NEW.transfer_status = 2 AND NEW.purged <> OLD.purged AND NEW.purged = 1 AND NEW.last_accessed IS NULL
BEGIN
  INSERT INTO synced_changes(event_content_part_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD._ROWID_, 2, (
    SELECT events.stream_database_identifier FROM events
    LEFT OUTER JOIN event_content_parts ON (events.database_identifier = event_content_parts.event_database_identifier)
    WHERE event_content_parts.database_identifier = NEW.database_identifier
  ));
END;

DROP TRIGGER IF EXISTS track_event_content_part_transfer_status_changes;
CREATE TRIGGER track_event_content_part_transfer_status_changes AFTER UPDATE OF transfer_status ON event_content_parts
WHEN NEW.transfer_status <> OLD.transfer_status AND NEW.purged = 0
BEGIN
  INSERT INTO synced_changes(event_content_part_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD._ROWID_, 1, (
    SELECT events.stream_database_identifier FROM events
    LEFT OUTER JOIN event_content_parts ON (events.database_identifier = event_content_parts.event_database_identifier)
    WHERE event_content_parts.database_identifier = NEW.database_identifier
  ));
END;

DROP TRIGGER IF EXISTS track_global_deletions_of_messages;
CREATE TRIGGER track_global_deletions_of_messages AFTER UPDATE OF deletion_mode ON messages
WHEN NEW.deletion_mode == 2
AND (SELECT deletion_mode FROM conversations WHERE database_identifier = NEW.conversation_database_identifier) = 0
BEGIN
INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('messages', NEW.database_identifier, 2);
END;

DROP TRIGGER IF EXISTS track_inserts_of_conversation_participants;
CREATE TRIGGER track_inserts_of_conversation_participants AFTER INSERT ON conversation_participants
WHEN NEW.stream_member_database_identifier IS NULL
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversation_participants', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_inserts_of_conversations;
CREATE TRIGGER track_inserts_of_conversations AFTER INSERT ON conversations
WHEN NEW.stream_database_identifier IS NULL
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversations', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_inserts_of_event_mutations;
CREATE TRIGGER track_inserts_of_event_mutations AFTER INSERT ON mutations
WHEN NEW.is_synchronized = 1 AND NEW.stream_database_identifier IS NULL AND NEW.event_database_identifier IS NOT NULL
BEGIN
  INSERT INTO synced_changes(mutation_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, (
    SELECT events.stream_database_identifier FROM events
    WHERE events.database_identifier = NEW.event_database_identifier
  ));
END;

DROP TRIGGER IF EXISTS track_inserts_of_events_delete;
CREATE TRIGGER track_inserts_of_events_delete AFTER INSERT ON events FOR EACH ROW
WHEN NEW.seq IS NOT NULL AND NEW.type = 9 AND NOT EXISTS (SELECT 1 FROM events WHERE client_id = NEW.client_id AND database_identifier != NEW.database_identifier) AND (SELECT database_identifier FROM events WHERE stream_database_identifier = NEW.stream_database_identifier AND seq = NEW.target_seq)
BEGIN
  INSERT INTO synced_changes(event_database_identifier, change_type, associated_stream_database_identifier) VALUES ((SELECT database_identifier FROM events WHERE stream_database_identifier = NEW.stream_database_identifier AND seq = NEW.target_seq), 2, NEW.stream_database_identifier);
  UPDATE events SET type = 10, subtype = NULL, external_content_id = NULL, member_id = NULL, target_seq = NULL WHERE database_identifier = (SELECT database_identifier FROM events WHERE stream_database_identifier = NEW.stream_database_identifier AND seq = NEW.target_seq);
END;

DROP TRIGGER IF EXISTS track_inserts_of_events_non_delete;
CREATE TRIGGER track_inserts_of_events_non_delete AFTER INSERT ON events FOR EACH ROW
WHEN NEW.seq IS NOT NULL AND NEW.type != 9 AND NOT EXISTS (SELECT 1 FROM events WHERE client_id = NEW.client_id AND database_identifier != NEW.database_identifier)
BEGIN
  INSERT INTO synced_changes(event_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_inserts_of_local_keyed_values;
CREATE TRIGGER track_inserts_of_local_keyed_values AFTER INSERT ON local_keyed_values
WHEN NEW.timestamp IS NULL
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('local_keyed_values', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_inserts_of_remote_keyed_values;
CREATE TRIGGER track_inserts_of_remote_keyed_values AFTER INSERT ON remote_keyed_values
WHEN NEW.timestamp NOT NULL
BEGIN
  INSERT INTO synced_changes(remote_keyed_value_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.object_id);
END;

DROP TRIGGER IF EXISTS track_inserts_of_stream_members;
CREATE TRIGGER track_inserts_of_stream_members AFTER INSERT ON stream_members
WHEN NEW.seq IS NOT NULL
BEGIN
  INSERT INTO synced_changes(stream_member_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW._ROWID_, 0, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_inserts_of_stream_mutations;
CREATE TRIGGER track_inserts_of_stream_mutations AFTER INSERT ON mutations
WHEN NEW.is_synchronized = 1 AND NEW.stream_database_identifier IS NOT NULL
BEGIN
  INSERT INTO synced_changes(mutation_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_inserts_of_streams;
CREATE TRIGGER track_inserts_of_streams AFTER INSERT ON streams
WHEN NEW.stream_id IS NOT NULL
BEGIN
  INSERT INTO synced_changes(stream_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.database_identifier);
END;

DROP TRIGGER IF EXISTS track_message_send_on_insert;
CREATE TRIGGER track_message_send_on_insert AFTER INSERT ON messages
WHEN NEW.seq IS NULL
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('messages', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_moving_last_read_message_position_of_conversation_participants;
CREATE TRIGGER track_moving_last_read_message_position_of_conversation_participants AFTER UPDATE OF marked_as_read_position ON conversation_participants
WHEN NEW.marked_as_read_position IS NOT NULL AND
  (NEW.marked_as_read_position > OLD.marked_as_read_position OR
    (NEW.marked_as_read_position IS NOT NULL and OLD.marked_as_read_position IS NULL)) AND
  (NEW.marked_as_read_seq = OLD.marked_as_read_seq OR
    (NEW.marked_as_read_seq IS NULL AND OLD.marked_as_read_seq IS NULL))
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversation_participants_last_read_position', NEW.database_identifier, 1);
END;

DROP TRIGGER IF EXISTS track_re_inserts_of_conversation_participants;
CREATE TRIGGER track_re_inserts_of_conversation_participants AFTER UPDATE OF deleted_at ON conversation_participants
WHEN NEW.seq IS NOT NULL AND NEW.seq = OLD.seq AND (NEW.deleted_at IS NULL AND OLD.deleted_at NOT NULL)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversation_participants', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_re_inserts_of_local_keyed_values;
CREATE TRIGGER track_re_inserts_of_local_keyed_values AFTER UPDATE OF deleted_at ON local_keyed_values
WHEN NEW.timestamp IS NULL AND (NEW.deleted_at IS NULL AND OLD.deleted_at NOT NULL)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('local_keyed_values', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_re_inserts_of_remote_keyed_values;
CREATE TRIGGER track_re_inserts_of_remote_keyed_values AFTER UPDATE OF deleted_at ON remote_keyed_values
WHEN NEW.timestamp NOT NULL AND (NEW.deleted_at IS NULL AND OLD.deleted_at NOT NULL)
BEGIN
  INSERT INTO synced_changes(remote_keyed_value_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.object_id);
END;

DROP TRIGGER IF EXISTS track_stream_distinct_updates;
CREATE TRIGGER track_stream_distinct_updates AFTER UPDATE OF is_distinct ON streams
WHEN NEW.is_distinct IS NOT NULL AND OLD.is_distinct IS NOT NULL AND NEW.is_distinct != OLD.is_distinct
BEGIN
  INSERT INTO synced_changes(stream_database_identifier, change_type, associated_stream_database_identifier) VALUES (OLD.database_identifier, 1, NEW.database_identifier);
END;

DROP TRIGGER IF EXISTS track_sync_deletions_of_messages;
CREATE TRIGGER track_sync_deletions_of_messages AFTER UPDATE OF deletion_mode ON messages
WHEN NEW.deletion_mode == 1
AND (SELECT deletion_mode FROM conversations WHERE database_identifier = NEW.conversation_database_identifier) = 0
AND (NOT EXISTS (SELECT target_seq FROM mutations WHERE target = 2 AND stream_id = (SELECT stream_id FROM conversations WHERE database_identifier = NEW.conversation_database_identifier))
OR (SELECT target_seq FROM mutations WHERE target = 2 AND stream_id = (SELECT stream_id FROM conversations WHERE database_identifier = NEW.conversation_database_identifier) ORDER BY seq DESC LIMIT 1) < NEW.seq)
BEGIN
INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('messages', NEW.database_identifier, 2);
END;

DROP TRIGGER IF EXISTS track_syncable_changes_for_message_receipts;
CREATE TRIGGER track_syncable_changes_for_message_receipts AFTER INSERT ON message_recipient_status
WHEN NEW.seq IS NULL AND ((SELECT seq FROM messages WHERE database_identifier = NEW.message_database_identifier) >= 0 OR (SELECT seq FROM messages WHERE database_identifier = NEW.message_database_identifier) IS NULL)
BEGIN
    INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('message_recipient_status', NEW.database_identifier, 0);
END;

DROP TRIGGER IF EXISTS track_updates_of_event_mutations;
CREATE TRIGGER track_updates_of_event_mutations AFTER UPDATE OF is_synchronized ON mutations
WHEN NEW.is_synchronized = 1 AND OLD.is_synchronized = 0 AND NEW.stream_database_identifier IS NULL
BEGIN
  INSERT INTO synced_changes(mutation_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, (
    SELECT events.stream_database_identifier FROM events
    WHERE events.database_identifier = NEW.event_database_identifier
  ));
END;

DROP TRIGGER IF EXISTS track_updates_of_event_seqs;
CREATE TRIGGER track_updates_of_event_seqs AFTER UPDATE OF seq ON events
WHEN NEW.seq IS NOT NULL AND OLD.seq IS NULL
BEGIN
  INSERT INTO synced_changes(event_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 1, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_updates_of_event_type_message_to_tombstone;
CREATE TRIGGER track_updates_of_event_type_message_to_tombstone AFTER UPDATE OF type ON events
WHEN NEW.type = 10 AND OLD.type = 4
BEGIN
  DELETE FROM event_content_parts WHERE event_database_identifier = NEW.database_identifier;
  DELETE FROM remote_keyed_values WHERE object_type = 'event' AND object_id = NEW.database_identifier;
END;

DROP TRIGGER IF EXISTS track_updates_of_local_keyed_values;
CREATE TRIGGER track_updates_of_local_keyed_values AFTER UPDATE OF value ON local_keyed_values
WHEN OLD.deleted_at IS NULL AND NEW.timestamp IS NULL AND (NEW.value != OLD.value)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('local_keyed_values', NEW.database_identifier, 1);
END;

DROP TRIGGER IF EXISTS track_updates_of_remote_keyed_values;
CREATE TRIGGER track_updates_of_remote_keyed_values AFTER UPDATE OF timestamp ON remote_keyed_values
WHEN NEW.timestamp NOT NULL AND OLD.deleted_at IS NULL AND (NEW.value != OLD.value)
BEGIN
  INSERT INTO synced_changes(remote_keyed_value_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 1, NEW.object_id);
END;

DROP TRIGGER IF EXISTS track_updates_of_starting_seq;
CREATE TRIGGER track_updates_of_starting_seq AFTER UPDATE OF starting_seq ON streams
WHEN OLD.starting_seq IS NULL AND NEW.starting_seq IS NOT NULL
BEGIN
  INSERT INTO synced_changes(stream_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 1, NEW.database_identifier);
END;

DROP TRIGGER IF EXISTS track_updates_of_stream_database_identifier_for_conversation;
CREATE TRIGGER track_updates_of_stream_database_identifier_for_conversation AFTER UPDATE OF stream_database_identifier ON conversations
WHEN (OLD.stream_id IS NULL AND NEW.stream_id IS NULL) OR OLD.stream_id = NEW.stream_id
BEGIN
  INSERT INTO synced_changes(stream_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.stream_database_identifier, 1, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_updates_of_stream_id_for_events;
CREATE TRIGGER track_updates_of_stream_id_for_events AFTER UPDATE OF stream_database_identifier ON events
WHEN NEW.stream_database_identifier IS NOT NULL AND OLD.stream_database_identifier IS NOT NULL AND NEW.stream_database_identifier != NEW.stream_database_identifier
BEGIN
  INSERT INTO synced_changes(event_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 1, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_updates_of_stream_mutations;
CREATE TRIGGER track_updates_of_stream_mutations AFTER UPDATE OF is_synchronized ON mutations
WHEN NEW.is_synchronized = 1 AND OLD.is_synchronized = 0 AND NEW.stream_database_identifier IS NOT NULL
BEGIN
  INSERT INTO synced_changes(mutation_database_identifier, change_type, associated_stream_database_identifier) VALUES (NEW.database_identifier, 0, NEW.stream_database_identifier);
END;

DROP TRIGGER IF EXISTS track_updates_of_streams;
CREATE TRIGGER track_updates_of_streams AFTER UPDATE OF stream_id ON streams
WHEN (NEW.stream_id IS NOT NULL AND OLD.stream_id IS NULL) OR
     (NEW.total_message_event_count <> OLD.total_message_event_count) OR
     (NEW.unread_message_event_count <> OLD.unread_message_event_count)
BEGIN
  INSERT INTO synced_changes(
    stream_database_identifier,
    change_type,
    associated_stream_database_identifier)
  VALUES (
    NEW.database_identifier,
    1,
    NEW.database_identifier);
END;
