# relational-metadata-profiling
Functional dependency discovery and Canonical Cover Computation on a relational airport database.
Project Overview
This project implements a data-driven functional dependency discovery system for relational datasets.
Given a tabular dataset, the system automatically:
1.	Discovers functional dependencies using a level-wise (Apriori-style) search
2.	Prunes non-minimal dependencies
3.	Computes the canonical cover by removing:
•	Extraneous attributes
•	Redundant dependencies
The project is inspired by classical database theory and modern metadata profiling systems such as Metanome and Metaserve.
Key Concepts
•	Functional Dependency Discovery
•	Minimal Left-Hand-Side (LHS) Pruning
•	Attribute Closure
•	Canonical Cover Reduction

