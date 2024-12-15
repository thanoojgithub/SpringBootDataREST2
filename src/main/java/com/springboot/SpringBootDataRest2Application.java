package com.springboot;

import jakarta.persistence.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

@SpringBootApplication
public class SpringBootDataRest2Application {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDataRest2Application.class, args);
	}
}

@Entity
@Table(name = "customer")
class Customer {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String name;
	private String branch;
	private Double balance;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBranch() {
		return branch;
	}

	public void setBranch(String branch) {
		this.branch = branch;
	}

	public Double getBalance() {
		return balance;
	}

	public void setBalance(Double balance) {
		this.balance = balance;
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || getClass() != o.getClass()) return false;
		Customer customer = (Customer) o;
		return Objects.equals(id, customer.id) && Objects.equals(name, customer.name) && Objects.equals(branch, customer.branch) && Objects.equals(balance, customer.balance);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, name, branch, balance);
	}
}

@RepositoryRestResource
interface CustomerRepository extends CrudRepository<Customer, Long> {
	List<Customer> findByBranch(@Param("branch") String branch);
	List<Customer> findByName(@Param("name") String name);
}

@Component
class CustomHealthIndicator implements HealthIndicator {

	@Override
	public Health health() {
		return Health.up().withDetail("Custom Health Check", "Application is running").build();
	}
}
