package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Persona;

public interface PersonaRepository extends JpaRepository<Persona, String> {
}
