# Knowlecule: NLP Tools







**Disclaimer**
This project is currently for informational and educational purposes only,

**Key Features**

* **Redis ORM with Ohm:** Provides object-relational mapping for storing and managing document metadata,  topics, sections, embeddings, and their relationships.
* **Document Structure:** Supports a variety of document types (text, images, audio, video) with metadata extraction.
* **NLP Integration:** Designed to incorporate NLP pipelines for tasks like:
   * Text summarization
   * Embedding generation
   * Topic modeling
   * Knowledge graph construction (future addition)

**NLP Libraries**

This project leverages a combination of powerful Ruby and Python libraries for a wide array of NLP tasks.

**Ruby:**

* **Text Processing and Analysis:**
   * **engtagger:**  Part-of-speech tagging.
   * **lemmatizer:** Reduces words to their root form (lemmatization).
   * **lingua:** Language identification.
   * **nokogiri:** HTML and XML parsing.
   * **pragmatic_segmenter, pragmatic_tokenizer:** Text segmentation and tokenization.
   * **ruby-spacy:** Access to SpaCy NLP models.
   * **syntax_tree:**  Syntactic parsing.
   * **wordnet, wordnet-defaultdb:** Access to the WordNet lexical database.
* **Document Format Handling:**
   * **docsplit:** Splits documents across various formats.
   * **hexapdf, pdf-reader, pdf_paradise, poppler:** PDF parsing and manipulation.
* **Topic Modeling:**
   * **epitome:**  LDA-based topic modeling.
   * **tomoto:** A variety of topic modeling algorithms.
* **Knowledge Representation:**
   * **graphr:** Graph data structures for knowledge graph construction.
* **LLM Frameworks:**
   * **hugging-face:** Access to pre-trained transformers and LLM integration.
   * **langchainrb:** Framework for building and interacting with LLM-powered applications.

**Python:**

* **txtaxi:**  Framework for building customizable NLP pipelines.
* **promptools:**  Tools for working with language model prompts, improving prompt engineering.

**Integration**

While the core data modeling is in Ruby, the project utilizes Python's strengths for specialized NLP tasks.  Tools like `pycall` facilitate communication between the Ruby and Python components of the project.


**Project Structure**

* **exe/knowlecule:**  The primary executable entry point.
* **lib/knowlecule:**
   * **config.rb:**  Centralized project configuration.
   * **db:** Handles database interactions (Redis, potentially PostgreSQL in the future).
   * **item:**  Models for various document types (document, image, audio, video).
   * **llm:**   Integration with Large Language Models (LLMs) from different providers, enabling NLP tasks.
   * **loader.rb:** Loads documents from various sources.
   * **parser.rb:**  Parses document content based on their file types.
   * **pipeline:**  Defines NLP processing pipelines with modules for text, audio, etc.
   * **ui.rb:**  Command-line interface components.
   * **utils:**  Supporting utility modules for data manipulation, logging, and more.
* **config.default.yml:** Default project configuration template.
* **test:** Contains test cases and supporting files.
* **vendor:** External dependencies.
* **docker:** Docker configuration for containerizing core components.
* **ansible:** Ansible playbooks and roles for infrastructure automation.

**Getting Started**

1. **Prerequisites:**
   * Ruby (version 2.7 or later)
   * Redis server
   * Docker (if using containerization)
   * Ansible (if using Ansible for infrastructure)
2. **Installation:**
   ```bash
   git clone https://github.com/your-username/knowlecule.git
   cd knowlecule
   bundle install
   ```
3. **Configuration:**
   * Copy `config.default.yml` to `config.yml` and edit as needed.
   * Ensure the `REDIS` environment variable points to your Redis instance.
4. **Run Basic Example:** (Adjust if not executable from the project root)
   ```bash
   ./exe/knowlecule
   ```

**Development**

* Follow existing coding conventions and style guides.
* Write test cases for new features.

**Roadmap**

* **Expand NLP Pipelines:** Add more sophisticated analysis capabilities to `lib/knowlecule/pipeline`.
* **Knowledge Graph:** Integrate graph database structures to represent interconnected knowledge from documents.
* **Search Interface:** Develop a user-friendly search interface to query the knowledge base.

**Contributions**

We welcome contributions!

1. Open an issue to discuss proposed changes.
2. Submit a pull request with well-documented changes and tests.
