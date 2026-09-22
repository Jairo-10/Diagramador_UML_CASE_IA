package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Inscripcion;

public interface InscripcionRepository extends JpaRepository<Inscripcion, String> {
}
