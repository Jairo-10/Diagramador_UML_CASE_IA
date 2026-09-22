package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Estudiante;

public interface EstudianteRepository extends JpaRepository<Estudiante, String> {
}
