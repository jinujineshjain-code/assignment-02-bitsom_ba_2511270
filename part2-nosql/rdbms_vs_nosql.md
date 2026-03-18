## Database Recommendation

For a healthcare startup building a patient management system, I would recommend **MySQL (RDBMS)** as the primary database, with the option to add MongoDB for specific modules like fraud detection.

**Why MySQL over MongoDB for the core system:**

Patient management systems deal with highly structured, interrelated data — patient demographics, doctor assignments, appointments, prescriptions, billing, and treatment history. This data has clear relationships that benefit enormously from a relational model. For example, a prescription must always be linked to a valid patient and a valid doctor. MySQL enforces these relationships through foreign keys, ensuring that orphaned or inconsistent records cannot exist. In healthcare, where data integrity can directly impact patient safety, this is non-negotiable.

MySQL also provides full **ACID compliance** — Atomicity, Consistency, Isolation, and Durability. This means that if a transaction fails halfway (e.g., a billing record is created but payment is not recorded), the entire operation is rolled back. In contrast, MongoDB follows the **BASE** model (Basically Available, Soft state, Eventually consistent), which prioritizes availability over strict consistency. For financial and medical records, eventual consistency is not acceptable — you need guaranteed consistency at all times.

From the perspective of the **CAP theorem**, MySQL prioritizes Consistency and Partition Tolerance, while MongoDB prioritizes Availability and Partition Tolerance. Again, for a patient management system where incorrect or stale data could lead to wrong diagnoses or double billing, consistency must always win over availability.

**Would the answer change for a fraud detection module?**

Yes, partially. A fraud detection module typically needs to process large volumes of semi-structured, fast-changing behavioral data — login patterns, transaction logs, device fingerprints — that do not fit neatly into fixed table schemas. MongoDB's flexible document model and horizontal scalability make it well-suited for this use case. Therefore, for the fraud detection module specifically, I would recommend adding MongoDB alongside MySQL, using each database for what it does best. This hybrid approach — MySQL for structured patient records and MongoDB for unstructured behavioral data — gives the startup both data integrity and analytical flexibility.
