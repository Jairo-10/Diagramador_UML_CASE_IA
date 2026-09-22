package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Calificacion;
import com.example.genapp.repository.CalificacionRepository;
import com.example.genapp.model.Inscripcion;
import com.example.genapp.repository.InscripcionRepository;

@Service
@RequiredArgsConstructor
public class CalificacionService {

    private final CalificacionRepository repository;
    private final InscripcionRepository inscripcionRepository;

    public List<Calificacion> findAll() {
        return repository.findAll();
    }

    public Optional<Calificacion> findById(Long id) {
        return repository.findById(id);
    }

    public Calificacion save(Calificacion e) {
        return repository.save(e);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public Optional<Inscripcion> findInscripcionById(Long id) {
        return inscripcionRepository.findById(id);
    }
}
