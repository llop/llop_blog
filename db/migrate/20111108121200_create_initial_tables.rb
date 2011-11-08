class CreateInitialTables < ActiveRecord::Migration
  def up
    # Tags
    execute <<-SQL
      create table tags ( 
        id serial not null primary key, 
        name character varying(32) not null 
      );
    SQL
    # Categories
    execute <<-SQL
      create table categories ( 
        id serial not null primary key, 
        name character varying(32) not null 
      );
    SQL
    # Posts + fulltext support
    execute <<-SQL
      create table posts ( 
        id serial not null primary key, 
        title character varying(128) not null, 
        summary text not null, 
        body text not null, 
        category_id integer not null references categories(id), 
        created_at timestamp without time zone not null, 
        updated_at timestamp without time zone not null
      );
    SQL
    execute <<-SQL
      create index textsearch_idx on posts using gin(( 
        setweight(to_tsvector('pg_catalog.english', title), 'A') || 
        setweight(to_tsvector('pg_catalog.english', summary), 'B') || 
        setweight(to_tsvector('pg_catalog.english', body), 'D')));
    SQL
    # Posts-Tags join table
    execute <<-SQL
      create table posts_tags ( 
        post_id integer not null references posts(id), 
        tag_id integer not null references tags(id), 
        primary key (post_id, tag_id) 
      );
    SQL
    # Comments
    execute <<-SQL
      create table comments ( 
        id serial not null primary key, 
        name character varying(36) not null, 
        email character varying(128) not null, 
        uri character varying(128) default null, 
        body text not null, 
        post_id integer not null references posts(id), 
        created_at timestamp without time zone not null 
      );
    SQL
  end
  
  def down
    # Drop tables in reverse order
    drop_table :comments
    drop_table :posts_tags
    drop_table :posts
    drop_table :categories
    drop_table :tags
  end
end
