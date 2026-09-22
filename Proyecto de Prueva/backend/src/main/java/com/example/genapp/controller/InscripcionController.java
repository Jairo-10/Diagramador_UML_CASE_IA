package com.example.genapp.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.example.genapp.model.Inscripcion;
import com.example.genapp.service.InscripcionService;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/inscripcion")
@RequiredArgsConstructor
public class InscripcionController {

    private final InscripcionService service;

    @GetMapping
    public List<Inscripcion> all() {
    return service.findAll();
    }

    @GetMapping("/{id}")
    public Inscripcion one(@PathVariable("id") String id) {
    return service.findById(id)
    .orElseThrow(() -> new RuntimeException("Inscripcion not found with id " + id));
    }

    @PostMapping
    public Inscripcion create(@RequestBody Map<String, Object> body) {
        Inscripcion entity = new Inscripcion();
        updateEntityFromMap(entity, body);
        return service.save(entity);
    }

    @PutMapping("/{id}")
    public Inscripcion update(@PathVariable("id") String id, @RequestBody Map<String, Object> updates) {
        // Verificar que el recurso existe antes de actualizar
        Inscripcion existing = service.findById(id)
            .orElseThrow(() -> new RuntimeException("Inscripcion not found with id " + id));
        
        updateEntityFromMap(existing, updates);
        return service.save(existing);
    }
    
    private void updateEntityFromMap(Inscripcion entity, Map<String, Object> data) {
        data.forEach((key, value) -> {
            try {
                // Manejar relación ManyToOne: boletin
                if (key.equals("boletinid") && value != null) {
                    Long relId = convertToLong(value);
                    service.findBoletinById(relId).ifPresent(entity::setBoletin);
                    return;
                }
                // Manejar relación ManyToOne: curso
                if (key.equals("cursoid") && value != null) {
                    Long relId = convertToLong(value);
                    service.findCursoById(relId).ifPresent(entity::setCurso);
                    return;
                }
                // Manejar relación ManyToOne: estudiante
                if (key.equals("estudianteid") && value != null) {
                    Long relId = convertToLong(value);
                    service.findEstudianteById(relId).ifPresent(entity::setEstudiante);
                    return;
                }
                
                String setterName = "set" + Character.toUpperCase(key.charAt(0)) + key.substring(1);
                java.lang.reflect.Method setter = Arrays.stream(entity.getClass().getMethods())
                    .filter(m -> m.getName().equals(setterName) && m.getParameterCount() == 1)
                    .findFirst()
                    .orElse(null);
                
                if (setter != null && value != null) {
                    Class<?> paramType = setter.getParameterTypes()[0];
                    Object convertedValue = convertValue(value, paramType);
                    setter.invoke(entity, convertedValue);
                }
            } catch (Exception e) {
                // Ignorar campos que no se puedan actualizar
            }
        });
    }
    
    private Long convertToLong(Object value) {
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        return Long.parseLong(value.toString());
    }
    
    private Object convertValue(Object value, Class<?> targetType) {
        if (value == null) return null;
        if (targetType.isInstance(value)) return value;
        
        String strValue = value.toString();
        if (targetType == Integer.class || targetType == int.class) return Integer.parseInt(strValue);
        if (targetType == Long.class || targetType == long.class) return Long.parseLong(strValue);
        if (targetType == Double.class || targetType == double.class) return Double.parseDouble(strValue);
        if (targetType == Float.class || targetType == float.class) return Float.parseFloat(strValue);
        if (targetType == Boolean.class || targetType == boolean.class) return Boolean.parseBoolean(strValue);
        if (targetType == BigDecimal.class) return new BigDecimal(strValue);
        if (targetType == LocalDate.class) return LocalDate.parse(strValue);
        if (targetType == LocalDateTime.class) return LocalDateTime.parse(strValue);
        
        return value;
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable("id") String id) {
    service.delete(id);
    }
}
