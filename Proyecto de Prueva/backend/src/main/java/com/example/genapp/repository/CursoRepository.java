package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Curso;

public interface CursoRepository extends JpaRepository<Curso, Long> {
}
