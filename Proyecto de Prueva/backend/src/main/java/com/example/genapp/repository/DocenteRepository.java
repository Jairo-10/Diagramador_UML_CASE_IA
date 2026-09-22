package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Docente;

public interface DocenteRepository extends JpaRepository<Docente, String> {
}
