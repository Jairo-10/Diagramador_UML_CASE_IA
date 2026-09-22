package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Calificacion;

public interface CalificacionRepository extends JpaRepository<Calificacion, Long> {
}
