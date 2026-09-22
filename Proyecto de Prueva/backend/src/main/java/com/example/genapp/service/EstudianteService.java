package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Estudiante;
import com.example.genapp.repository.EstudianteRepository;

@Service
@RequiredArgsConstructor
public class EstudianteService {

    private final EstudianteRepository repository;

    public List<Estudiante> findAll() {
        return repository.findAll();
    }

    public Optional<Estudiante> findById(String id) {
        return repository.findById(id);
    }

    public Estudiante save(Estudiante e) {
        return repository.save(e);
    }

    public void delete(String id) {
        repository.deleteById(id);
    }
}
