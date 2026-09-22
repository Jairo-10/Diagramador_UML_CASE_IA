package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Docente;
import com.example.genapp.repository.DocenteRepository;
import com.example.genapp.model.Curso;
import com.example.genapp.repository.CursoRepository;

@Service
@RequiredArgsConstructor
public class DocenteService {

    private final DocenteRepository repository;
    private final CursoRepository cursoRepository;

    public List<Docente> findAll() {
        return repository.findAll();
    }

    public Optional<Docente> findById(String id) {
        return repository.findById(id);
    }

    public Docente save(Docente e) {
        return repository.save(e);
    }

    public void delete(String id) {
        repository.deleteById(id);
    }

    public Optional<Curso> findCursoById(Long id) {
        return cursoRepository.findById(id);
    }
}
