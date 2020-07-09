#!/usr/bin/env ruby
# frozen_string_literal: true

# nodoc
class BackupCheck
  def initialize
    @project = 'pitc-decidim-zuerich-int'
  end

  def run
    start_output
    switch_project
    create
  end

  def start_output
    `set +ex`
  end

  def switch_project
    `oc project #{@project}`
  end

  def create
    `echo "#{config}" | oc create -f -`
  end

  def config
    <<~CONFIG
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: rsync-target
      spec:
        activeDeadlineSeconds: 2147483647
        terminationGracePeriodSeconds: 0
        restartPolicy: Never
        containers:
        - name: target
          image: rails:latest
          command:
          - sleep
          - infinity
          resources:
            limits:
              cpu: 1
              memory: 1Gi
            requests:
              cpu: 10m
              memory: 20Mi
          volumeMounts:
          - mountPath: /mnt/uploads
            name: active-storage
          - mountPath: /mnt/postgresql-backup
            name: postgresql-backup
        volumes:
        - name: active-storage
          persistentVolumeClaim:
            claimName: active-storage
        - name: postgresql-backup
          persistentVolumeClaim:
            claimName: postgresql-backup
      ...
    CONFIG
  end
end

BackupCheck.new.run
