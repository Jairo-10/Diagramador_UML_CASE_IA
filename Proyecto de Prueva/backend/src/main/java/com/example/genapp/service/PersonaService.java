package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Persona;
import com.example.genapp.repository.PersonaRepository;

@Service
@RequiredArgsConstructor
public class PersonaService {

    private final PersonaRepository repository;

    public List<Persona> findAll() {
        return repository.findAll();
    }

    public Optional<Persona> findById(String id) {
        return repository.findById(id);
    }

    public Persona save(Persona e) {
        return repository.save(e);
    }

    public void delete(String id) {
        repository.deleteById(id);
    }
}
