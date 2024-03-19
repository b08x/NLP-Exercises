## Knowlecule Redis ORM with Ohm

This project provides object-relational mapping (ORM) functionality for storing and retrieving document-related data in Redis using the Ohm gem. It models the following entities:

* **Document:** Represents a single document with attributes like title, content, and summary.
* **Subject:**  Represents a subject or topic, with attributes like name, description, and associated vector.
* **Section:**  Represents a section within a document, including content, summary, embeddings, and references to the parent document and subject.
* **Word:** Represents individual words within a document, including its term, embeddings, and associated references.
* **Token:** Represents individual characters within a word.
* **Embedding:** Represents a numerical vector representation (embedding) of a textual element (word, phrase, section, etc.).

**Key Features**

* **Relationships:** Establishes clear relationships between documents, subjects, sections, and words.
* **Indexing:** Provides indexing for key attributes to enable efficient search and retrieval.
* **Embeddings:**  Supports storing and associating embeddings with various textual elements.


**Usage**

1. **Configure Redis connection:** Set the `REDIS` environment variable to your Redis instance's URL (e.g., `redis://localhost:6379`).

2. **Create a Document:**
   ```ruby
   document = Document.create(title: "My Document", content: "Document content here...")
   ```

3. **Find a Document:**
   ```ruby
   document = Document.find(title: "My Document").first
   ```

4. **Associate with Subjects, Sections, etc.:** Use the references defined in the models to establish relationships.

**Example**

```ruby
# ... (Redis configuration from above) ...

document = Document.create(title: "Introduction to NLP", content: "...")

subject = Subject.create(name: "Natural Language Processing", description: "...")

section = Section.create(content: "The first section content...", document: document, subject: subject)

# ... more operations to add words, tokens, embeddings, etc.
```

**Development**

To run the code in this project, execute the `./exe/knowlecule.rb` file which includes `require_relative 'lib/knowlecule'`.

**Note:** This project includes comments and placeholder logic for integrating NLP capabilities. Further development is required to implement those functionalities.

**Future Roadmap**

Here are some potential enhancements you might want to include:

* **Full-text Search:** Implement search capabilities across document content and summaries.
* **NLP Integration:** Complete the NLP integration to generate embeddings and textual summaries.

**Contributions**

Contributions are welcome! Please follow these guidelines:

* Open an issue to discuss proposed changes before submitting a pull request.
* Follow existing code style and conventions.
