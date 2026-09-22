package com.example.genapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.genapp.model.Boletin;

public interface BoletinRepository extends JpaRepository<Boletin, String> {
}
