package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Curso;
import com.example.genapp.repository.CursoRepository;
import com.example.genapp.model.Curso;
import com.example.genapp.repository.CursoRepository;

@Service
@RequiredArgsConstructor
public class CursoService {

    private final CursoRepository repository;
    private final CursoRepository cursoPadreRepository;

    public List<Curso> findAll() {
        return repository.findAll();
    }

    public Optional<Curso> findById(Long id) {
        return repository.findById(id);
    }

    public Curso save(Curso e) {
        return repository.save(e);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public Optional<Curso> findCursoById(Long id) {
        return cursoPadreRepository.findById(id);
    }
}
