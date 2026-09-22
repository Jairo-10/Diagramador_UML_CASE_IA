package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Inscripcion;
import com.example.genapp.repository.InscripcionRepository;
import com.example.genapp.model.Boletin;
import com.example.genapp.repository.BoletinRepository;
import com.example.genapp.model.Curso;
import com.example.genapp.repository.CursoRepository;
import com.example.genapp.model.Estudiante;
import com.example.genapp.repository.EstudianteRepository;

@Service
@RequiredArgsConstructor
public class InscripcionService {

    private final InscripcionRepository repository;
    private final BoletinRepository boletinRepository;
    private final CursoRepository cursoRepository;
    private final EstudianteRepository estudianteRepository;

    public List<Inscripcion> findAll() {
        return repository.findAll();
    }

    public Optional<Inscripcion> findById(String id) {
        return repository.findById(id);
    }

    public Inscripcion save(Inscripcion e) {
        return repository.save(e);
    }

    public void delete(String id) {
        repository.deleteById(id);
    }

    public Optional<Boletin> findBoletinById(Long id) {
        return boletinRepository.findById(id);
    }

    public Optional<Curso> findCursoById(Long id) {
        return cursoRepository.findById(id);
    }

    public Optional<Estudiante> findEstudianteById(Long id) {
        return estudianteRepository.findById(id);
    }
}
