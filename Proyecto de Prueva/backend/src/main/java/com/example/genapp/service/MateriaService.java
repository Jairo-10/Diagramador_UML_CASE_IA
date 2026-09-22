package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Materia;
import com.example.genapp.repository.MateriaRepository;

@Service
@RequiredArgsConstructor
public class MateriaService {

    private final MateriaRepository repository;

    public List<Materia> findAll() {
        return repository.findAll();
    }

    public Optional<Materia> findById(Long id) {
        return repository.findById(id);
    }

    public Materia save(Materia e) {
        return repository.save(e);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }
}
