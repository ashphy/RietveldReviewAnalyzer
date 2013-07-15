# Rietveld Review Analyzer

Review Analysis Tools for Rietveld, a code review tool

## Requirements
- Ruby 1.9.3 or later
- ActiveRecord 3.2.13 or later

## Analysis Preparation
1. Install ActiveRecord with bundler

        > bundle install

2. Setup DB

    You can use any databases that rails supported (MySQL, PostgreSQL, SQLite).
    And write your settings into database.yml

3. Apply schema

    Use rietveld.sql or rietveld.mwb to apply schema

4. Get review data

    We can provide a review data obtained from chromium project here http://sdlab.naist.jp/reviewmining/

5. Importing review data to DB

        > ruby rietveld_import_to_mysql.rb REVIEW_DATA_FILE.json 

6. Run alalysis scripts

    We are providing some example script in the example directory.

## License
MIT: http://rem.mit-license.org
