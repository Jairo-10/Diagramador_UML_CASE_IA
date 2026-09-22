package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.DocenteMateria;
import com.example.genapp.repository.DocenteMateriaRepository;
import com.example.genapp.model.Docente;
import com.example.genapp.repository.DocenteRepository;
import com.example.genapp.model.Materia;
import com.example.genapp.repository.MateriaRepository;

@Service
@RequiredArgsConstructor
public class DocenteMateriaService {

    private final DocenteMateriaRepository repository;
    private final DocenteRepository docenteRepository;
    private final MateriaRepository materiaRepository;

    public List<DocenteMateria> findAll() {
        return repository.findAll();
    }

    public Optional<DocenteMateria> findById(Long id) {
        return repository.findById(id);
    }

    public DocenteMateria save(DocenteMateria e) {
        return repository.save(e);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public Optional<Docente> findDocenteById(Long id) {
        return docenteRepository.findById(id);
    }

    public Optional<Materia> findMateriaById(Long id) {
        return materiaRepository.findById(id);
    }
}
