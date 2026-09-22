package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Materia;

public interface MateriaRepository extends JpaRepository<Materia, Long> {
}
